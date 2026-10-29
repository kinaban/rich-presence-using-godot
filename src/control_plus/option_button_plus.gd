extends OptionButton

# Setting this to 0 means there's no height limit.
@export var popup_maximum_height: int


func _ready() -> void:
	resized.connect(_on_resized)
	toggled.connect(_on_toggled)


func _on_resized() -> void:
	var popup := get_popup()
	
	var new_size := Vector2i(int(size.x), popup_maximum_height)
	popup.max_size = new_size
	popup.size = Vector2(new_size.x, popup.size.y)
	
	# We also correct the position because the popup's position on x axis
	# seems to go to 0 when changing its size.
	var new_position := global_position
	new_position.y += get_rect().size.y
	popup.position = new_position


# This is done so that when the window size is very wide
# the popup would still match button width.
func _on_toggled(_is_toggled: bool) -> void:
	_on_resized()
