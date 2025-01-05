# Godot-Text-File-Data-Persistence

#### add(field_name:String, field_value:Variant) -> Variant
Add a new field to the data dict. If the field already exists, it will do nothing, and return void.

#### remove(field_name:String) -> Variant
Removes a field. If the field does not exist, it will present a error message.

#### update(field_name:String, field_value:Variant) -> Variant
Update the value of an existing field.


---

 #### Basic Example
```gdscript
extends Node

var player_health:int = 50


func _ready() -> void:
	if !Data.data_dict_exists("PlayerData"):
		Data.new_data_dict("PlayerData")

	if !Data.data["PlayerData"].exists("Health"):
		Data.data["PlayerData"].add("Health", 50)

	Data.data["PlayerData"].update("Health", 20)

	if !Data.data["PlayerData"].exists("Mana"):
		Data.data["PlayerData"].add("Mana", 50)

	Data.data["PlayerData"].save()

	Data.data["PlayerData"].remove("Health")

```
