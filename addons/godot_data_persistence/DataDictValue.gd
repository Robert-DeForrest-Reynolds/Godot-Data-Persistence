class_name DataDictValue

var value
var value_type_int
var value_type
var types_representation


func _init(initial_value:Variant) -> void:
	value = initial_value
	value_type_int = typeof(value)
	if value_type_int == TYPE_OBJECT:
		Error.new("Non-primitive type are unsupported")
		value = null
	else:
		value_type = type_string(value_type_int)
