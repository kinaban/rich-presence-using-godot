# Contributing Guidelines
This document establishes the standard practices to be followed when contributing to "Rich Presence Using Godot".

## Add New Configuration
To implement a new configuration support the following steps can be followed:<br>


1. Create a new setget variable inside `presence.config` to store the new data.<br>

2. Edit the following inside `profile_config_resource.gd`:<br>
	1. Create a unique constant key in `profile_config_resource.config`<br>
	2. Add save support by adding a `config.set_value()` for it inside `profile_config_resource.gd: _on_presence_config_change()`<br>
	3. Add load support by setting the variable you've created in step 1 to `config.get_value()` using the key you've created in step 2 inside `profile_config_resource.gd: get_presence()`<br>

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
