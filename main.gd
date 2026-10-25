extends PanelContainer

## Don't make this a constant.
var profile_config_resource := preload("uid://dhg8yctepbdw1")

var discord_presence : DiscordRichPresence
var presence_config := profile_config_resource.get_presence("1")

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


func _on_application_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		presence_config.app_id = application_edit.text


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
		discord_presence = DiscordRichPresence.new()
		discord_presence.app_id = application_edit.text
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
	
	elif is_instance_valid(discord_presence):
		discord_presence.clear_activity()
		discord_presence.queue_free()
	
	else:
		push_error("Presence not found when toggling off enable.")
		return
	
	presence_config.is_enabled = toggled_on
