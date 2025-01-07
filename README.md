# Godot-Text-File-Data-Persistence

All DataDict objects are stored as plain text files. They are essentially CSV files, but the default delimiter is `~`. You can change the delimiter if you'd like, but if you do so afterward saving and DataDicts, you will have to convert those files.



All DataDicts are placed in the "user://Data" directory. During launch, any DataDicts within that directory are automatically loaded on startup.



Currently only int, float, String, Vector2, and Vector2i are supported data types to reload. I hope to support the rest of the data types soon.


All functions have snake_case forms as well as PascalCase, because well, I just prefer PascalCase.

---

## Data Methods
#### `func new_data_dict(dict_name:String) -> Variant`
Creates a new DataDict with the specified name.

#### `func save_all() -> Variant`
Saves all existing DataDicts at once.

---

## DataDict Methods

#### `add(field_name:String, field_value:Variant) -> Variant`
#### `add(fields:Dictionary) -> Variant`
Add a new field, or fields if given a Dictionary, to the data dict. If the field already exists, it will do nothing, and return void. If you add a non-primitive type, an error will pop, and the field will not be added.

#### `remove(field_name:String) -> Variant`
#### `remove(field_names:Array) -> Variant`
Removes a field, or fields if given an Array. If the field does not exist, it will present a error message.

#### `update(field_name:String, field_value:Variant) -> Variant`
#### `update(fields:Dictionary) -> Variant`
Update the value or values fi given a dictonary, of an existing field.

#### `save() -> void`
Saves the data dict to a text file.

---

 #### Basic Example of Creating DataDict, and Adding Fields
```gdscript
extends Node2D

var ui_volume:float = 12.0
var music_volume:float = 12.0

var player_health:int = 50
var player_mana

func _ready() -> void:
	Data.new_data_dict("player_data")

	Data.data["player_data"].add("health", player_health)
	Data.data["player_data"].add("mana", player_health)

	player_health -= 20
	# You can update a single field
	Data.data["player_data"].update("health", player_health)

	# Or you can update multiple fields
	Data.data["player_data"].update({"health": player_health,
					 "mana": player_mana
					 })

	Data.data["player_data"].add("position", position)

	# Write DataDict to disk in plain text file
	Data.data["player_data"].save()

	Data.new_data_dict("settings")

	Data.data["settings"].add({"ui_volume":ui_volume,
				   "music_volume:":music_volume,
				   })

	Data.data["settings"].save()
```

#### Example of Loading in Data from Existing Fields

```gdscript
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
```




Work In Progress Documentation: https://godot-text-file-data-persistence.readthedocs.io/en/latest/
