@tool

extends Label

@export var fallback_version := "0.0.0" ## Used when project settings version is empty
@export var prefix := "v" ## The text before the version
@export var prefix_enabled := true


func _ready() -> void:
	_update_settings()
	
	ProjectSettings.settings_changed.connect(_on_settings_changed)


func _get_configuration_warnings() -> PackedStringArray:
	var warning_list := PackedStringArray()
	var version := str(ProjectSettings.get_setting("application/config/version"), "")
	
	if version.is_empty():
		warning_list.append("Project Settings version is empty")
	
	return warning_list



func _update_settings() -> void:
	var version := str(ProjectSettings.get_setting("application/config/version"), "")
	var actual_version := fallback_version if version.is_empty() else version
	var actual_prefix := prefix if prefix_enabled else ""
	
	text = "%s%s" % [actual_prefix, actual_version]
	update_configuration_warnings()


func _on_settings_changed() -> void:
	_update_settings()
