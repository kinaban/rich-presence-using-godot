extends ConfigResource

const APP_ID_KEY := "app_id"
const PROCESS_PATH_KEY := "process_path"
const DETAILS_KEY := "details"
const STATE_KEY := "state"
const ASSETS_LARGE_IMAGE_KEY := "assets_large_image"
const ENABLE_KEY := "is_enabled"


func _on_presence_config_change(new_presence_config: PresenceConfig) -> void:
	var section := new_presence_config.section
	
	config_file.set_value(section, APP_ID_KEY, new_presence_config.app_id)
	config_file.set_value(section, PROCESS_PATH_KEY, new_presence_config.process_path)
	config_file.set_value(section, DETAILS_KEY, new_presence_config.details)
	config_file.set_value(section, STATE_KEY, new_presence_config.state)
	config_file.set_value(section, ASSETS_LARGE_IMAGE_KEY, new_presence_config.assets_large_image)
	config_file.set_value(section, ENABLE_KEY, int(new_presence_config.is_enabled))
	
	have_changes = true


func get_presence(section: String) -> PresenceConfig:
	var presence_config := PresenceConfig.new()
	presence_config.section = section
	
	presence_config.app_id = str(config_file.get_value(section, APP_ID_KEY, ""))
	presence_config.process_path = str(config_file.get_value(section, PROCESS_PATH_KEY, ""))
	presence_config.details = str(config_file.get_value(section, DETAILS_KEY, ""))
	presence_config.state = str(config_file.get_value(section, STATE_KEY, ""))
	presence_config.assets_large_image = str(config_file.get_value(section, ASSETS_LARGE_IMAGE_KEY, ""))
	presence_config.is_enabled = Parser.get_bool(config_file.get_value(section, ENABLE_KEY, 0))
	
	presence_config.changed.connect(_on_presence_config_change.bind(presence_config))
	
	return presence_config
