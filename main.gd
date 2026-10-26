extends PanelContainer

## Don't make this a constant.
var profile_config_resource := preload("uid://dhg8yctepbdw1")

var discord_presence : DiscordRichPresence
var presence_config := profile_config_resource.get_presence("1")
var default_process_index := 0 # Index where it should never be cleared when refreshing process list.

@onready var application_edit: LineEdit = %ApplicationEdit
@onready var process_option: OptionButton = %ProcessOption
@onready var details_edit: LineEdit = %DetailsEdit
@onready var state_edit: LineEdit = %StateEdit
@onready var large_image_edit: LineEdit = %LargeImageEdit
@onready var enable_button: CheckButton = %EnableButton


func _ready() -> void:
	application_edit.text = presence_config.app_id
	
	var process_path := presence_config.process_path
	if process_path.is_empty() == false:
		var index := _add_item(process_path)
		process_option.select(index)
		default_process_index += 1
		prints("Set process option index to", index, process_path)
	
	details_edit.text = presence_config.details
	state_edit.text = presence_config.state
	large_image_edit.text = presence_config.assets_large_image
	
	# This will only emit signal if true, because the default is already false
	enable_button.set_pressed(presence_config.is_enabled)
	
	refresh()


func _on_refresh_process_button_pressed() -> void:
	refresh()


func refresh() -> void:
	## This deletes the old process list.
	## Do not delete the first item.
	for i in range(process_option.item_count - 1, default_process_index, -1):
		process_option.remove_item(i)
	
	var path_list := RunningProcess.get_path_list()
	
	for path in path_list:
		_add_item(path)


func _add_item(process_path: String) -> int:
	var index := process_option.item_count
	process_option.add_item("Process: " + process_path)
	process_option.set_item_metadata(index, process_path)
	return index


func _on_application_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		presence_config.app_id = application_edit.text


func _on_process_option_item_selected(index: int) -> void:
	prints("Index", index)
	var path = process_option.get_item_metadata(index)
	
	if path is String:
		presence_config.process_path = path
	
	else:
		presence_config.process_path = ""


func _on_details_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		presence_config.details = details_edit.text


func _on_state_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		presence_config.state = state_edit.text


func _on_large_image_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		presence_config.assets_large_image = large_image_edit.text


func _on_enable_button_toggled(toggled_on: bool) -> void:
	prints("Enabled button", toggled_on)
	
	if toggled_on:
		update_activity()

	
	elif is_instance_valid(discord_presence):
		discord_presence.clear_activity()
		discord_presence.queue_free()
	
	else:
		push_error("Presence not found when toggling off enable.")
		return
	
	presence_config.is_enabled = toggled_on


func _on_update_button_pressed() -> void:
	if presence_config.is_enabled == false : return
	
	elif is_instance_valid(discord_presence) == false:
		push_error("Invalid discord presence")
	
	else:
		update_activity()


func update_activity() -> void:
	var app_id := application_edit.text
	
	if is_instance_valid(discord_presence):
		if discord_presence.app_id != app_id:
			discord_presence.queue_free()
			discord_presence = null
			prints("Cleared")
	
	# Check again incase it was deleted.
	if is_instance_valid(discord_presence) == false:
		discord_presence = DiscordRichPresence.new()
		discord_presence.app_id = app_id
		add_child(discord_presence)
	
	discord_presence.set_activity({
		"details" : details_edit.text,
		"state" : state_edit.text,
		"timestamps" : {
			"start" : int(Time.get_unix_time_from_system())
		},
		"assets" : {
			"large_image" : large_image_edit.text,
		}
	})
