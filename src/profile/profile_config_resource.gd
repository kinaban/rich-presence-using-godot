extends ConfigResource

const APP_ID_KEY := "app_id"
const DETAILS_KEY := "details"
const STATE_KEY := "state"
const ASSETS_LARGE_IMAGE_KEY := "assets_large_image"


func update_presence(presence_config: PresenceConfig) -> void:
	var section := presence_config.unique_id
	
	config_file.set_value(section, APP_ID_KEY, presence_config.app_id)
	config_file.set_value(section, DETAILS_KEY, presence_config.details)
	config_file.set_value(section, STATE_KEY, presence_config.state)
	config_file.set_value(section, ASSETS_LARGE_IMAGE_KEY, presence_config.assets_large_image)
	
	have_changes = true
