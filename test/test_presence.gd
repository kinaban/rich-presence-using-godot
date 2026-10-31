extends Node

func  _ready() -> void:
	var presence := DiscordRichPresence.new()
	presence.app_id = "1561749949119467671"
	add_child(presence)

	presence.set_activity({
		"details": "Coding something",
		"state": "Level 99",
		"timestamps": {"start" : int(Time.get_unix_time_from_system())},
		"assets": {"large_image": "icon"},
	})
