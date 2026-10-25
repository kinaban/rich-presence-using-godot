extends PanelContainer

var presence : DiscordRichPresence

@onready var application_edit: LineEdit = %ApplicationEdit
@onready var process_option: OptionButton = %ProcessOption
@onready var details_edit: LineEdit = %DetailsEdit
@onready var state_edit: LineEdit = %StateEdit
@onready var large_image_edit: LineEdit = %LargeImageEdit


func _ready() -> void:
	refresh()


func _on_refresh_process_button_pressed() -> void:
	refresh()


func refresh() -> void:
	## This deletes the old process list.
	## Do not delete the first item.
	for i in range(process_option.item_count - 1, 0, -1):
		process_option.remove_item(i)
	
	var path_list := RunningProcess.get_path_list()
	
	for path in path_list:
		process_option.add_item("Process: " + path)


func _on_enable_button_toggled(toggled_on: bool) -> void:
	prints("Enabled button", toggled_on)
	
	if toggled_on:
		presence = DiscordRichPresence.new()
		presence.app_id = application_edit.text
		add_child(presence)
		
		presence.set_activity({
			"details" : details_edit.text,
			"state" : state_edit.text,
			"timestamps" : {
				"start" : int(Time.get_unix_time_from_system())
			},
			"assets" : {
				"large_image" : large_image_edit.text,
			}
		})
	
	elif is_instance_valid(presence):
		presence.clear_activity()
		presence.queue_free()
	
	else:
		push_error("Presence not found when toggling off enable.")
