class_name RunningProcess

extends RefCounted


static func _get_path_list_linuxbsd() -> PackedStringArray:
	var path_list := PackedStringArray()
	var proc_dir := DirAccess.open("/proc")
	
	proc_dir.list_dir_begin()
	
	while true:
		var pid := proc_dir.get_next()
		
		# End of directory has been reached.
		if pid.is_empty() : break
		
		var pid_path := "/proc/%s/exe" % pid
		var output := []
		var exit_code := OS.execute("readlink", ["-f", pid_path], output)
		
		if exit_code != 0 or output.is_empty() : continue
		
		var path := str(output[0]).strip_edges()
		
		if path.is_empty() : continue
		
		path_list.append(path)
	
	proc_dir.list_dir_end()
	return path_list


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


static func get_pid_list() -> PackedStringArray:
	if OS.has_feature("linux"):
		return _get_linux_pid_list()
	
	push_error("Your OS '%s' is not supported by 'get_pid_list()'." % OS.get_name())
	return PackedStringArray()


static func get_path_list() -> PackedStringArray:
	var list := PackedStringArray()
	
	if OS.has_feature("linuxbsd"):
		return _get_path_list_linuxbsd()
	
	push_error("Your OS '%s' is not supported." % OS.get_name())
	return list
