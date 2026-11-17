# Contributing Guidelines
This document establishes the standard practices to be followed when contributing to "Rich Presence Using Godot".

## Adding Presence Configuration
To implement a new presence configuration support, follow the steps below:<br>

1. Create a new setget variable inside `presence_config.gd` to store the new data. This variable shall be represented as `CONFIG_VARIABLE` within the examples in this section.<br>

2. Edit the following inside `profile_config_resource.gd`:<br>
	1. Create a unique constant key to represent the new configuration data. This constant shall be represented as `CONFIG_KEY` within the examples in this section.<br>
	2. Add save support by going to `_on_presence_config_change()` and insert `config_file.set_value(section, CONFIG_KEY, CONFIG_VARIABLE)`.<br>
	3. Add load support by going to `get_presence()` and insert `presence_config.CONFIG_VARIABLE = config.get_value(section, CONFIG_KEY, "")`. You may enclose it in str, int or any other types to enforce a data type.<br>

3. Go inside `main.tscn` to edit the GUI.<br>

4. Guidelines for one liner configurations, skip this step if not applicable:
	1. Use or inherit `line_edit_plus.gd`.
	2. Set `placeholder_text` to a short description of its purpose.<br>
	3. Set `clear_button_enabled` to true.<br>
	4. Set `caret_blink` to true.<br>
	5. Set `custom_minimum_size` to Vector2(0, 35).<br>
	6. Give the node a unique name, and include `Edit` as a suffix.
	7. Enable `Access as Unique Name`.
	8. Connect `editing_toggled` signal to the root node of the scene. The new function created by this shall be represented as `CONNECT_FUNCTION` within the examples in this sublist.
	9. Open `main.gd` for next steps below.
	10. Store a typed reference of the node by using `@onready`. This onready variable shall be represented as `CONFIG_NODE` within the examples in this sublist.
	11. Load saved data going to `_ready()` and adding `CONFIG_NODE.text = presence_config.CONFIG_VARIABLE`.
	12. Save new changes by going inside the `CONNECT_FUNCTION` and check if the `toggled_on` is false then `presence_config.CONFIG_VARIABLE = CONFIG_NODE.text`.
	13. Make this show up in the presence by first going to `updated_activity()`, second check if `CONFIG_NODE.text.is_empty() == false`, third include it in the `activity_table`.

## Pull Request
All contributions must use pull requests and follow the requirements below.<br>

PR Titles must begin with one of the following:
- Add
	- Description: Creating or extending a feature and/or documentation
	- Example/s:
		- Add settings button to the main scene
		- Add flowchart to configuration update
- Fix
	- Description: Correcting a feature to work as intended and/or correcting a mistake in the documentation
	- Example/s:
		- Fix presence not showing up in Windows 11
		- Fix a typo in the `README.md` description
	- Change
	- Description: Replacing an existing feature which does not increase its functionality or changing a documentation which does not add new information
	- Example/s:
		- Change configuration text to gray
		- Change button style to use theme
		- Change documentation titles to be centered
		- Change `settings.tscn` name to `settings_button.tscn`
		- Change `about.tscn` directory to `src/about/`
