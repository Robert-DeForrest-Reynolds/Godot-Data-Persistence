extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Data.register_class(CustomClass, ["example_var"])
	Data.initialize()
	if !Data.data_dict_exists("CustomClassInstances"):
		Data.new_data_dict("CustomClassInstances")

	var NewCustomClass = CustomClass.new()

	if !Data.data["CustomClassInstances"].exists("CustomClass1"):
		Data.data["CustomClassInstances"].add("CustomClass1", NewCustomClass)

	Data.data["CustomClassInstances"].save()
