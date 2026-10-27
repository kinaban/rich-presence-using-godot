extends PanelContainer

## Don't make this a constant.
var profile_config_resource := preload("uid://dhg8yctepbdw1")

var discord_presence : DiscordRichPresence
var presence_config := profile_config_resource.get_presence("1")

var pid_path_table: Dictionary[String, String]
var path_pid_list_table: Dictionary[String, PackedStringArray]

@onready var app_id_edit: LineEdit = %AppIdEdit
@onready var app_name_edit: LineEdit = %AppNameEdit
@onready var process_option: OptionButton = %ProcessOption
@onready var details_edit: LineEdit = %DetailsEdit
@onready var state_edit: LineEdit = %StateEdit
@onready var large_image_edit: LineEdit = %LargeImageEdit
@onready var enable_button: CheckButton = %EnableButton


func _ready() -> void:
	app_id_edit.text = presence_config.app_id
	app_name_edit.text = presence_config.app_name
	
	var process_path := presence_config.process_path
	if process_path.is_empty() == false:
		var index := _add_item(process_path)
		process_option.select(index)
		
		# This prevents duplication on process_option when saved path matches a running application.
		path_pid_list_table[process_path] = PackedStringArray()
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
	var start := Time.get_ticks_msec()
	var new_pid_list := RunningProcess.get_pid_list()
	var fresh_pid_list := PackedStringArray()
	
	for pid in new_pid_list:
		if pid_path_table.has(pid) : continue
		fresh_pid_list.append(pid)
	
	var fresh_path_list := RunningProcess.pid_to_path_list(fresh_pid_list)
	
	for i in range(fresh_path_list.size()):
		var path := fresh_path_list[i]
		var pid := fresh_pid_list[i]
		
		# We still add empty pid to the cache in order to not use expensive readlink on them again.
		pid_path_table[pid] = path
		
		if path.is_empty() == false:
			# This prevents path duplication in the process_option.
			if path_pid_list_table.has(path) == false:
				_add_item(path)
			
			var path_pid_list: PackedStringArray = path_pid_list_table.get(path, PackedStringArray())
			path_pid_list.append(pid)
			path_pid_list_table[path] = path_pid_list
	
	var elapsed := Time.get_ticks_msec() - start
	prints("Refresh elapsed (msec):", elapsed)


func _add_item(process_path: String) -> int:
	var index := process_option.item_count
	process_option.add_item("Process: " + process_path)
	process_option.set_item_metadata(index, process_path)
	return index


# Refactor me
func _on_app_id_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		presence_config.app_id = app_id_edit.text


func _on_app_name_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on == false:
		presence_config.app_name = app_name_edit.text


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
	
	update_activity()


func update_activity() -> void:
	var app_id := app_id_edit.text
	
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
	
	var app_name := app_name_edit.text
	var activity_table := {
		"name" : app_name,
		"details" : details_edit.text,
		"state" : state_edit.text,
		"timestamps" : {
			"start" : int(Time.get_unix_time_from_system())
		},
		"assets" : {
			"large_image" : large_image_edit.text,
		}
	}
	
	if app_name.is_empty():
		activity_table.erase("name")
	
	discord_presence.set_activity(activity_table)
