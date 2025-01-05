# Godot-Text-File-Data-Persistence

All DataDict objects are stored as plain text files. They are essentially CSV files, but the default delimiter is `~`. You can change the delimiter if you'd like, but if you do so afterward saving and DataDicts, you will have to convert those files.

All primitives types are supported.

---

## Data Methods
#### `func new_data_dict(dict_name:String) -> Variant`
Creates a new DataDict with the specified name.

#### `func save_all() -> Variant`
Saves all existing DataDicts at once.

---

## DataDict Methods

#### `add(field_name:String, field_value:Variant) -> Variant`
Add a new field to the data dict. If the field already exists, it will do nothing, and return void.

#### `remove(field_name:String) -> Variant`
Removes a field. If the field does not exist, it will present a error message.

#### `update(field_name:String, field_value:Variant) -> Variant`
Update the value of an existing field.

#### `save() -> void`
Saves the data dict to a text file.

---

 #### Basic Example
```gdscript
extends Node

var ui_volume = 12

var player_health:int = 50

func _ready() -> void:
	Data.new_data_dict("player_data")

	Data.data["player_data"].add("health", player_health)

	player_health -= 20

	Data.data["player_data"].update("health", player_health)

	Data.data["player_data"].add("mana", 50)

	Data.data["player_data"].save()

	Data.data["player_data"].remove("health")

	Data.new_data_dict("Settings")

	Data.data["settings"].add("ui_volume", ui_volumce)

	Data.data["settings"].save()

```
