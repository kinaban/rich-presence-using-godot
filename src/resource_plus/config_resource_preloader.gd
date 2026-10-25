extends ResourcePreloader

@export var wait_time := 1.0


func _ready() -> void:
	get_tree().create_timer(wait_time).timeout.connect(_on_timer_timeout)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			soft_save_all()


func _on_timer_timeout() -> void:
	soft_save_all()
	
	get_tree().create_timer(wait_time).timeout.connect(_on_timer_timeout)


func add_resource_plus(new_name: StringName, new_resource: Resource) -> void:
	if new_resource is ConfigResource:
		super.add_resource(new_name, new_resource)
		new_resource.setup()
	
	else:
		push_error("New resource '%s' does not inherit ConfigResource" % new_name)


func soft_save_all() -> void:
	for resource in get_config_resource_list():
		resource.soft_save()


func get_config_resource_list() -> Array[ConfigResource]:
	var config_resource_list: Array[ConfigResource] = []
	
	for resource_name in get_resource_list():
		var resource := get_resource(resource_name)
		
		if is_instance_valid(resource) == false : continue
		
		if resource is ConfigResource:
			config_resource_list.append(resource)
	
	return config_resource_list
