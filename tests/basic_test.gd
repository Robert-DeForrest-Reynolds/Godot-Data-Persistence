extends Node


class InnerCustomClass:
	# must have a variable named inner_class_name to be registerable
	var inner_class_name = "InnerCustomClass"
	var example_value = 50


# Internal variable
var player_health:int = 50


func _ready() -> void:
	if !Data.data_dict_exists("PlayerData"):
		Data.new_data_dict("PlayerData")

	# Use primitive types
	if !Data.data["PlayerData"].exists("Health"):
		Data.data["PlayerData"].add("Health", 50)

	Data.data["PlayerData"].update("Health", 20)

	if !Data.data["PlayerData"].exists("Mana"):
		Data.data["PlayerData"].add("Mana", 50)

	Data.data["PlayerData"].save()

	Data.data["PlayerData"].remove("Health")
