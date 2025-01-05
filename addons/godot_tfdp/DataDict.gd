class_name DataDict extends Node


class DictValue:
	var value
	var value_type_int
	var value_type
	var types_representation

	func _init(initial_value:Variant) -> void:
		value = initial_value
		value_type_int = typeof(value)
		if value_type_int == TYPE_OBJECT:
			Data.Error.new("Non-primitive type are unsupported")
			value = null
		else:
			value_type = type_string(value_type_int)


var fields:Dictionary = {}


func _init(data_dict_name:String) -> void:
	name = data_dict_name


func add(field_name, field_value:Variant=null) -> Variant:
	if typeof(field_name) == TYPE_STRING:
		if field_name in fields.keys(): return
		var dict_value = DictValue.new(field_value)
		if dict_value.value == null:
			return Data.Error.new("Error Adding Field: most likely due to non-primitive type being used", false)
		fields[field_name] = dict_value
		return
	else:
		# Treat field_name as Dictionary, essentially field_names
		for field in field_name.keys():
			if field in fields.keys(): continue
			var dict_value = DictValue.new(field_name[field])
			if dict_value.value == null:
				Data.Error.new("Error Adding Field: most likely due to non-primitive type being used, will continue adding the rest of the items.", false)
				continue
			fields[field] = dict_value
		return


func update(field_name:Variant, field_value:Variant=null) -> Variant:
	if typeof(field_name) == TYPE_STRING:
		if not field_name in fields.keys():
			return Data.Error.new("Error Updating Field: %s doesn't exist" % [field_name, name], false)
		var dict_value = DictValue.new(field_value)
		fields[field_name] = dict_value
		return
	else:
		# Treat field_name as Dictionary, essentially field_names
		for field in field_name.keys():
			var new_dict_value = DictValue.new(field_name[field])
			fields[field] = new_dict_value
		return


func remove(removal:Variant) -> Variant:
	if typeof(removal) == TYPE_STRING:
		if not removal in fields.keys():
			return Data.Error.new("Error Removing Field: %s doesn't exist in %s" % [removal, name], false)
		if fields[removal] is not RefCounted:
			fields[removal].free()
		fields.erase(removal)
		return
	else:
		for field_name in removal:
			if not field_name in fields.keys():
				return Data.Error.new("Error Removing Field: %s doesn't exist" % [field_name, name], false)
			fields.erase(field_name)
		return


func exists(check:Variant) -> bool:
	if typeof(check) == TYPE_STRING:
		if check in fields.keys():
			return true
		return false
	else:
		for field_name in check:
			if not field_name in fields.keys():
				return false
		return true


func save() -> void:
	var file = FileAccess.open(Data.Path + "/%s.txt" % name, FileAccess.WRITE)
	var data = ""
	var size = fields.size() - 1
	var line_counter = 0
	for field in fields.keys():
		data += Data.delimiter.join([field, str(fields[field].value), str(fields[field].value_type)])
		if line_counter != size:
			data += "\n"
	file.store_string(data)
	file.close()


func load_from_file() -> Variant:
	var file = FileAccess.open(Data.Path + "/%s.txt" % name, FileAccess.READ)
	if file == null:
		return Data.Error.new("Unknown error, but could not load %s even though it supposedly exists" % name)
	for line in file.get_as_text().split("\n"):
		if line == "": continue
		var line_data = line.split(Data.delimiter)
		var dict_value = DictValue.new(line_data[1])
		var type = Data.types_representation[line_data[2]]
		match type:
			TYPE_INT:
				dict_value.value_type = type_string(type)
				dict_value.value = type_convert(dict_value.value, type)
			TYPE_STRING:
				dict_value.value_type = type_string(type)
			TYPE_FLOAT:
				dict_value.value_type = type_string(type)
				dict_value.value = type_convert(dict_value.value, type)
			TYPE_VECTOR2:
				dict_value.value_type = type_string(type)
				var coords = dict_value.value.split(",")
				dict_value.value = Vector2(float(coords[0].replace("(", "")), float(coords[1].replace(")", "")))
			TYPE_VECTOR2I:
				dict_value.value_type = type_string(type)
				var coords = dict_value.value.split(",")
				dict_value.value = Vector2(int(coords[0].replace("(", "")), int(coords[1].replace(")", "")))
		fields[line_data[0]] = dict_value
		print(dict_value.value)
	file.close()
	return
