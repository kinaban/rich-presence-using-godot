extends PanelContainer


func _on_close_button_pressed() -> void:
	hide()


func _on_godot_description_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)


func _on_discord_plugin_description_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
