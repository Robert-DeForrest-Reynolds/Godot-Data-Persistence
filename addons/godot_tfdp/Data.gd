extends Node

var main_loop = Engine.get_main_loop()
var scene_root = main_loop.get_root()

var Path = "user://Data"

var data = {}

var delimiter = "~"

var types_representation = {
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
			Data.types_representation[type_string] = type_value
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


func data_dict_exists(dict_name:String) -> bool:
	if dict_name in data.keys():
		return true
	return false


func save_all() -> void:
	for data_dict in data:
		data_dict.save()


func new_data_dict(dict_name:String) -> Variant:
	if dict_name in data.keys():
		return
	data[dict_name] = DataDict.new(dict_name)
	return data[dict_name]
