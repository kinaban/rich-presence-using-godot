extends Node


func _ready() -> void:
	var start := Time.get_ticks_msec()
	var list := RunningProcess.get_pid_list()
	var elapsed := Time.get_ticks_msec() - start
	
	prints("Elapsed (msec):", elapsed)
	
	for i in list.size():
		prints(i, list[i])
