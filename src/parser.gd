class_name Parser

extends RefCounted

const BOOL_TRUE_LIST := ["yes", "true", "1", "y", "enabled", "enable"]
const BOOL_FALSE_LIST := ["no", "false", "0", "n", "disabled", "disable", ""]


static func get_bool(variant: Variant, fallback := false) -> bool:
	var type := typeof(variant)
	
	match type:
		TYPE_BOOL, TYPE_FLOAT, TYPE_INT:
			return bool(variant)
		
		TYPE_STRING:
			var string := str(variant).strip_escapes().strip_edges().to_lower()
			
			if string.is_empty():
				return false
			
			if BOOL_TRUE_LIST.has(string):
				return true
			
			if BOOL_FALSE_LIST.has(string):
				return false
	
	return fallback
