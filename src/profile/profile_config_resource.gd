extends ConfigResource

const APP_ID_KEY := "app_id"
const DETAILS_KEY := "details"
const STATE_KEY := "state"
const ASSETS_LARGE_IMAGE_KEY := "assets_large_image"


func _on_presence_config_change(new_presence_config: PresenceConfig) -> void:
	var section := new_presence_config.unique_id
	
	config_file.set_value(section, APP_ID_KEY, new_presence_config.app_id)
	config_file.set_value(section, DETAILS_KEY, new_presence_config.details)
	config_file.set_value(section, STATE_KEY, new_presence_config.state)
	config_file.set_value(section, ASSETS_LARGE_IMAGE_KEY, new_presence_config.assets_large_image)
	
	have_changes = true


func get_presence(unique_id: String) -> PresenceConfig:
	var presence_config := PresenceConfig.new()
	presence_config.unique_id = unique_id
	
	presence_config.changed.connect(_on_presence_config_change)
	
	return presence_config
