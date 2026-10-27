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


static func _linux_pid_to_path_list(new_pid_list: PackedStringArray) -> PackedStringArray:
	var path_list := PackedStringArray()
	
	for pid in new_pid_list:
		var pid_path := "/proc/%s/exe" % pid
		var output := []
		var exit_code := OS.execute("readlink", ["-f", pid_path], output)
		
		if exit_code != 0 or output.is_empty() : continue
		
		var path := str(output[0]).strip_edges()
		
		if path.is_empty() : continue
		
		path_list.append(path)
	
	return path_list


static func _get_linux_path_list() -> PackedStringArray:
	var pid_list := _get_linux_pid_list()
	
	return _linux_pid_to_path_list(pid_list)


static func get_pid_list() -> PackedStringArray:
	if OS.has_feature("linux"):
		return _get_linux_pid_list()
	
	push_error("Your OS '%s' is not supported by 'get_pid_list()'." % OS.get_name())
	return PackedStringArray()


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
