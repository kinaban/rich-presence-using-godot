class_name PresenceConfig

extends RefCounted

signal changed

## Just something unique to differentiate presence from one another.
var unique_id := "1"

var app_id: String:
	set(new_app_id):
		app_id = new_app_id
		changed.emit()

var details: String:
	set(new_details):
		details = new_details
		changed.emit()

var state: String:
	set(new_state):
		state = new_state
		changed.emit()

var assets_large_image: String:
	set(new_assets_large_image):
		assets_large_image = new_assets_large_image
		changed.emit()

var is_enabled: bool:
	set(new_enabled):
		is_enabled = new_enabled
		changed.emit()
