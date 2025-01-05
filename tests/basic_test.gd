extends Node

var player_health:int = 50


func _ready() -> void:
	Data.new_data_dict("PlayerData")

	Data.data["PlayerData"].add("Health", 50)

	Data.data["PlayerData"].update("Health", 20)

	Data.data["PlayerData"].add("Mana", 50)

	Data.data["PlayerData"].save()

	Data.data["PlayerData"].remove("Health")
