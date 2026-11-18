# Contributing Guidelines
This document establishes the standard practices to be followed when contributing to "Rich Presence Using Godot".

## GDScript Style
This guideline follows and builds upon [GDScript style guide - v4.7](https://docs.godotengine.org/en/4.7/tutorials/scripting/gdscript/gdscript_styleguide.html) unless otherwise specified below.

Additional guidelines are included below:<br>
1. Use static typing wherever possible.<br>
2. Access nodes using unique names where possible.<br>
3. Use Guard Clause where it makes sense to minimize nesting.<br>
4. Signals must always connect on their own dedicated function using the Godot's default format of `_on_{NODE_NAME}_{SIGNAL_NAME}`.<br>
5. Avoid excessive abstraction, only separate code into its own function and script when needed.<br>
6. Minimize the usage of `class_name` when dealing with node types to avoid polluting add node popup.<br>
7. Prefer simpler design, and only optimize when needed.<br>
8. Follow single source of truth where possible.<br>
9. Only the owner node should have direct access to the nodes it own.<br>
10. Strictly follow `Call down, signal up` as explained in [Node communication (the right way)](https://kidscancode.org/godot_recipes/4.x/basics/node_communication/index.html) by `KidsCanCode`.

## Adding Presence Configuration
To implement a new presence configuration support, follow the steps below:<br>

1. Create a new setget variable inside `presence_config.gd` to store the new data. This variable shall be represented as `CONFIG_VARIABLE` within the examples in this section.<br>

2. Edit the following inside `profile_config_resource.gd`:<br>
	1. Create a unique constant key to represent the new configuration data. This constant shall be represented as `CONFIG_KEY` within the examples in this section.<br>
	2. Add save support by going to `_on_presence_config_change()` and insert `config_file.set_value(section, CONFIG_KEY, CONFIG_VARIABLE)`.<br>
	3. Add load support by going to `get_presence()` and insert `presence_config.CONFIG_VARIABLE = config.get_value(section, CONFIG_KEY, "")`. You may enclose it in str, int or any other types to enforce a data type.<br>

3. Go inside `main.tscn` to edit the GUI.<br>

4. Guidelines for one liner configurations, skip this step if not applicable:
	1. Use or inherit `line_edit_plus.gd`.<br>
	2. Set `placeholder_text` to a short description of its purpose.<br>
	3. Set `clear_button_enabled` to true.<br>
	4. Set `caret_blink` to true.<br>
	5. Set `custom_minimum_size` to Vector2(0, 35).<br>
	6. Give the node a unique name, and include `Edit` as a suffix.<br>
	7. Enable `Access as Unique Name`.<br>
	8. Connect `editing_toggled` signal to the root node of the scene. The new function created by this shall be represented as `CONNECT_FUNCTION` within the examples in this sublist.<br>
	9. Open `main.gd` for next steps below.<br>
	10. Store a typed reference of the node by using `@onready`. This onready variable shall be represented as `CONFIG_NODE` within the examples in this sublist.<br>
	11. Load saved data going to `_ready()` and adding `CONFIG_NODE.text = presence_config.CONFIG_VARIABLE`.<br>
	12. Save new changes by going inside the `CONNECT_FUNCTION` and check if the `toggled_on` is false then `presence_config.CONFIG_VARIABLE = CONFIG_NODE.text`.<br>
	13. Make this show up in the presence by first going to `updated_activity()`, second check if `CONFIG_NODE.text.is_empty() == false`, third include it in the `activity_table`.<br>

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
