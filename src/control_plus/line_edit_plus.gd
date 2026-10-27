extends LineEdit


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)


## This sends the focus to the next gui
func _on_text_submitted(_new_text: String) -> void:
	var control := find_next_valid_focus()
	
	if is_instance_valid(control):
		control.grab_focus()
