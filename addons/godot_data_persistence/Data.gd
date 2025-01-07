class_name Data
extends Node

# Users when developing games tend to save:
# - whole objects, or specific properties of objects
# - lists of integers or floats that represent a multitude of states, or values
# - specific fields that are uncategorized, and are better off as key value pairs

# User when developing games reload data, and require:
# - objects to be reinstantiated as whole, or with specific properties
# - lists of integers or floats spread across a multitude of specific objects, or values
#	- more specifically ui needs to be filled out generally
# 	- profile data needs to be filled out
# essentially, there needs to be a `_data_injection` phase

var main_loop = Engine.get_main_loop()
var scene_root = main_loop.get_root()

static var Path = "user://Data"

static var data = {}

static var delimiter = "~"

static var types_representation = {
}


class Error:
	var scene_root = Engine.get_main_loop().get_root()
	func _init(error_message:String, fail_fast=false) -> void:
		if fail_fast == true:
			error_message += "\n\nCrashing Application to Avoid Corruption"
		OS.alert(error_message, "Data Persistence Error")
		if fail_fast == true:
			scene_root.quit()


func _ready() -> void:
	print("Loading Data Persistence")
	for type_value in range(Variant.Type.TYPE_NIL, Variant.Type.TYPE_MAX):
		var type_string = type_string(type_value)
		if type_string != "":
			types_representation[type_string] = type_value
	if !DirAccess.dir_exists_absolute(Path):
		DirAccess.make_dir_absolute(Path)
	check_for_existing_data_dicts()
	print("Data Persistence Loaded")


func check_for_existing_data_dicts() -> Variant:
	for file in DirAccess.get_files_at(Path):
		var data_dict_name = file.split(".")[0]
		var data_dict = new_data_dict(data_dict_name)
		data_dict.load_from_file()
	return


static func Data_Dict_Exists(DictName:String) -> bool:
	return data_dict_exists(DictName)


static func data_dict_exists(dict_name:String) -> bool:
	if dict_name in data.keys():
		return true
	return false


static func Save_All() -> void:
	save_all()


static func save_all() -> void:
	for data_dict in data:
		data_dict.save()


static func New_Data_Dict(DictName:String) -> Variant:
	return new_data_dict(DictName)


static func new_data_dict(dict_name:String) -> Variant:
	if dict_name in data.keys():
		return
	data[dict_name] = DataDict.new(dict_name)
	return data[dict_name]
