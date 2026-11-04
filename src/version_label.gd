extends Label

@export var fallback := "0.0.0" ## Used when project settings version is empty
@export var prefix := "v" ## The text before the version
@export var prefix_enabled := true


func _ready() -> void:
	_update_settings()
	
	ProjectSettings.settings_changed.connect(_on_settings_changed)


func _update_settings() -> void:
	var version := str(ProjectSettings.get_setting("application/config/version"), "")
	var actual_version := fallback if version.is_empty() else version
	var actual_prefix := prefix if prefix_enabled else ""
	
	text = "%s%s" % [actual_prefix, actual_version]


func _on_settings_changed() -> void:
	_update_settings()
