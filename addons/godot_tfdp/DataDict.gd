class_name DataDict extends Node

# need to support:
#  - Array (primitives only)
#  - Dictionary (primitive only(

# Register custom inner classes?

# Example of inner CustomClass
class DictValue:
	var value
	var value_type_int
	var value_type
	var types_representation

	func _init(initial_value:Variant) -> void:
		value = initial_value
		value_type_int = typeof(value)
		if value_type_int == TYPE_OBJECT:
			var script = value.get_script()
			# If is a class_name script
			if script.source_code != "":
				value_type = value.get_script().get_global_name()
				Data.types_representation[value_type] = value_type_int
			# If it is a inner class within another script
			else:
				value_type = Data.inner_custom_classes[Data.inner_custom_classes.find(value.inner_class_name)]
		else:
			value_type = type_string(value_type_int)


var fields:Dictionary = {}


func _init(data_dict_name:String) -> void:
	name = data_dict_name


func add(field_name:String, field_value:Variant) -> Variant:
	if field_name in fields.keys():
		return Data.Error.new("Error Adding Field: %s already exists in %s" % [field_name, name], false)
	if field_value is Object:
		for property in field_value.get_property_list():
			print(property)
	var dict_value = DictValue.new(field_value)
	fields[field_name] = dict_value
	return


func add_multiple(new_fields:Dictionary) -> Variant: return


# RefCounted objects don't need to be freed
func update(field_name:String, field_value:Variant) -> Variant:
	if not field_name in fields.keys():
		return Data.Error.new("Error Updating Field: %s doesn't exist" % [field_name, name], false)
	if fields[field_name] is not RefCounted:
		fields[field_name].free()
	var dict_value = DictValue.new(field_value)
	fields[field_name] = dict_value
	return


func update_multiple(new_fields:Dictionary) -> Variant: return


func remove(field_name:String) -> Variant:
	if not field_name in fields.keys():
		return Data.Error.new("Error Removing Field: %s doesn't exist" % [field_name, name], false)
	if fields[field_name] is not RefCounted:
		fields[field_name].free()
	fields.erase(field_name)
	return


func remove_multiple(field_names:Array) -> Variant: return


func save():
	var file = FileAccess.open(Data.Path + "/%s.txt" % name, FileAccess.WRITE)
	var data = ""
	var size = fields.size() - 1
	var line_counter = 0
	for field in fields.keys():
		data += "~".join([field, str(fields[field].value), str(fields[field].value_type)])
		if line_counter != size:
			data += "\n"
	file.store_string(data)
	file.close()


func exists_multiple(field_names:Array) -> Variant: return


func exists(field_name:String) -> bool:
	if field_name in fields.keys():
		return true
	return false


func load_from_file() -> Variant:
	var file = FileAccess.open(Data.Path + "/%s.txt" % name, FileAccess.READ)
	if file == null:
		return Data.Error.new("Unknown error, but could not load %s even though it supposedly exists" % name)
	for line in file.get_as_text().split("\n"):
		if line == "": continue
		var line_data = line.split("~")
		var dict_value = DictValue.new(line_data[1])
		var type = Data.types_representation[line_data[2]]
		if typeof(type) == TYPE_INT:
			dict_value.value_type = type_string(type)
			dict_value.value = type_convert(dict_value.value, type)
		else:
			dict_value.value_type = Data.types_representation.keys()[Data.types_representation.values().find(line_data[2])]
			# Value needs to be serialized
			OS.alert("Need to serialize")
		fields[line_data[0]] = dict_value
	file.close()
	return
