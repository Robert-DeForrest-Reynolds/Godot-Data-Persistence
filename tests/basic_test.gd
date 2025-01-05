extends Node2D

var ui_volume:float = 12.0
var music_volume:float = 12.0

var player_health:int = 50
var player_mana


func create_data_dicts():
	Data.new_data_dict("player_data")

	Data.data["player_data"].add({"health": player_health,
								  "position": position
								  })

	Data.data["player_data"].save()


func load_data():
	position = Data.data["player_data"].fields["position"].value
	player_health = Data.data["player_data"].fields["health"].value


func _ready() -> void:
	load_data()
	create_data_dicts()
