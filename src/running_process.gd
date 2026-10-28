class_name RunningProcess

extends RefCounted


static func _get_linux_pid_list() -> PackedStringArray:
	var pid_list := PackedStringArray()
	var proc_dir := DirAccess.open("/proc")
	
	proc_dir.list_dir_begin()
	
	while true:
		var pid := proc_dir.get_next()
		
		# End of directory has been reached.
		if pid.is_empty() : break
		
		pid_list.append(pid)
	
	return pid_list


## If a pid is invalid its index is filled with empty string,[br]
## which is done in order to maintain the same indexing as the new_pid_list.
static func _linux_pid_to_path_list(new_pid_list: PackedStringArray) -> PackedStringArray:
	var path_list := PackedStringArray()
	
	if new_pid_list.is_empty() : return path_list
	
	path_list.resize(new_pid_list.size())
	var argument_list := ["-m"] # Use -m in order to prevent skipping invalid pid path.
	
	for i in range(new_pid_list.size()):
		var pid := new_pid_list[i]
		var pid_path := "/proc/%s/exe" % pid
		
		argument_list.append(pid_path)
	
	var output := []
	var exit_code := OS.execute("readlink", argument_list, output)
	
	if output.is_empty():
		push_error("Empty output")
		return path_list
	
	if exit_code != 0:
		push_error("Error '%d' while executing readlink on _linux_pid_to_path_list" % exit_code)
		return path_list
	
	var output_string := str(output[0]).strip_edges()
	var output_split := output_string.split("\n")
	
	if output_split.size() != new_pid_list.size():
		push_error("output_split size '%d' doesn't match new_pid_size '%d'" % [output_split.size(), new_pid_list.size()])
		return path_list
	
	for i in range(output_split.size()):
		var path := str(output_split[i]).strip_edges()
		
		# This filters pid with invalid path, but also filters out some system processes, which is a nice side effect.
		if path == argument_list[i + 1]:
			path_list[i] = ""
			continue
		
		path_list[i] = path
	
	return path_list


static func _get_linux_path_list() -> PackedStringArray:
	var pid_list := _get_linux_pid_list()
	
	return _linux_pid_to_path_list(pid_list)


static func get_pid_list() -> PackedStringArray:
	if OS.has_feature("linux"):
		return _get_linux_pid_list()
	
	push_error("Your OS '%s' is not supported by 'get_pid_list()'." % OS.get_name())
	return PackedStringArray()


## @deprecated: Use [member pid_to_path_list] instead.
static func get_path_list() -> PackedStringArray:
	var list := PackedStringArray()
	
	if OS.has_feature("linux"):
		return _get_linux_path_list()
	
	push_error("Your OS '%s' is not supported." % OS.get_name())
	return list


static func pid_to_path_list(new_pid_list: PackedStringArray) -> PackedStringArray:
	if OS.has_feature("linux"):
		return _linux_pid_to_path_list(new_pid_list)
	
	push_error("Your OS '%s' is not supported by 'pid_to_path_list()'." % OS.get_name())
	return PackedStringArray()
