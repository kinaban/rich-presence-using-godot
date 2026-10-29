class_name NodePlus

extends Node


static func get_target_descendants(target: Node, include_internal := false) -> Array[Node]:
	var descendants := target.get_children(include_internal)
	
	for child in descendants:
		var new_descendants := child.get_children(include_internal)
		descendants.append_array(new_descendants)
	
	return descendants
