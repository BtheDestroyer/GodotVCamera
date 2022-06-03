extends Reference

var properties : Array = []
var instance

func _init(instance) -> void:
	self.instance = instance

func append(name : String, property_hint : int = PROPERTY_HINT_NONE, hint_string : String = "", property_usage = PROPERTY_USAGE_DEFAULT):
	if not name in instance:
		printerr("Property " + name + " doesn't exist")
		return
	
	var type = typeof(instance.get(name))
	if (type == TYPE_NIL and property_hint == PROPERTY_HINT_NONE) or property_hint == PROPERTY_HINT_RESOURCE_TYPE:
		type = TYPE_OBJECT # Failsafe for Resources. Use append_resource instead.
	
	var new_property = {
		name = name,
		type = type,
		hint = property_hint,
		hint_string = hint_string,
		usage = property_usage
	}
	
	properties.append(new_property)

func append_resource(name : String, resource_class : String, property_usage = PROPERTY_USAGE_DEFAULT):
	if not name in instance:
		printerr("Property " + name + " doesn't exist")
		return
	
	var new_property = {
		name = name,
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = resource_class,
		usage = property_usage
	}
	
	properties.append(new_property)

func append_number_range(name : String, min_value : float, max_value : float, step : float = -1, exponential := false, allow_lesser := false, allow_greater := false, property_usage = PROPERTY_USAGE_DEFAULT):
	if not name in instance:
		printerr("Property " + name + " doesn't exist")
		return
	
	var hint_string = "%s,%s" % [min_value, max_value]
	if step > 0:
		hint_string += ",%s" % step
	
	if allow_lesser:
		hint_string += ",or_lesser"
	
	if allow_greater:
		hint_string += ",or_greater"
	
	var new_property = {
		name = name,
		type = typeof(instance.get(name)),
		hint = PROPERTY_HINT_EXP_RANGE if exponential else PROPERTY_HINT_RANGE,
		hint_string = hint_string,
		usage = property_usage
	}
	
	properties.append(new_property)

func append_enum(name : String, of_enum : Dictionary, allow_other_values : bool = false, property_usage = PROPERTY_USAGE_DEFAULT):
	if not name in instance:
		printerr("Property " + name + " doesn't exist")
		return
	
	match typeof(instance.get(name)):
		TYPE_INT, TYPE_REAL:
			allow_other_values = false
		TYPE_STRING:
			pass
		_:
			printerr("Property " + name + " isn't of type int, float or String")
			return
	
	var hint_string : String = ""
	for key in of_enum.keys():
		hint_string += "%s:%s," % [key.capitalize(), of_enum[key]]
	hint_string = hint_string.rstrip(",")
	
	var new_property = {
		name = name,
		type = typeof(instance.get(name)),
		hint = PROPERTY_HINT_ENUM_SUGGESTION if allow_other_values else PROPERTY_HINT_ENUM,
		hint_string = hint_string,
		usage = property_usage
	}
	
	properties.append(new_property)

func append_enum_flags(name : String, of_enum : Dictionary, property_usage = PROPERTY_USAGE_DEFAULT):
	if not name in instance:
		printerr("Property " + name + " doesn't exist")
		return
	
	if typeof(instance.get(name)) != TYPE_INT:
		printerr("Property " + name + " isn't of type int")
		return
	
	var max_val = 0
	for val in of_enum.values():
		max_val = max(max_val, val)
	
	var hint_string : String = ""
	for i in int(sqrt(max_val)) + 1:
		var found := false
		for key in of_enum.keys():
			if of_enum[key] == pow(2, i):
				hint_string += "%s," % key.capitalize()
				found = true
		if not found:
			hint_string += ","
	
	hint_string = hint_string.rstrip(",")
	
	var new_property = {
		name = name,
		type = TYPE_INT,
		hint = PROPERTY_HINT_FLAGS,
		hint_string = hint_string,
		usage = property_usage
	}
	
	properties.append(new_property)

func append_category(begins_with : String, name : String = ""):
	if not name:
		name = begins_with.capitalize()
	
	properties.append({
		name = name,
		type = TYPE_NIL,
		hint_string = begins_with,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
