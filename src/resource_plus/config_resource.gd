class_name ConfigResource

extends Resource

var config_file := ConfigFile.new()
var have_changes: bool ## True if there are new changes since the last save

@export var path: String:
	set(new_path):
		path = new_path
		var error := config_file.load(path)
		
		if error == OK:
			prints("Successfully loaded file from '%s'" % [path])
			_loaded()
		
		else:
			prints("Failed to load file from '%s' with error %d" % [path, error])


## Overwrite this function for running things after loading the config_file
func _loaded() -> void : pass


## Only saves if there are pending changes
func soft_save() -> void:
	if have_changes:
		save()


func save() -> void:
	have_changes = false
	
	var base_dir := path.get_base_dir()
	var dir_error := DirAccess.make_dir_recursive_absolute(base_dir)
	
	if dir_error != OK:
		printerr("Failed to create dir recursively on '%s'" % base_dir)
	
	
	var error := config_file.save(path)
	
	if error == OK:
		print("File saved on '%s'" % [path])
	
	else:
		printerr("Failed to save file on '%s' with error %d" % [path, error])


func get_sections() -> PackedStringArray:
	return config_file.get_sections()


func get_value(new_section: String, new_key: String, default: Variant = null) -> Variant:
	return config_file.get_value(new_section, new_key, default)
