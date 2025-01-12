class_name Data extends Control

# There is a default set of information saved, this helps with getting up and running,
# and as well are good analytics to maybe keep in
#	- current scene
#	- settings file
#		- resolution, window type, video settings, etc.
#		- audio settings

# This library is meant to facilitate a basic need for database interaction with a game
# There are a lot of game implementation that probably cannot use this library,
# but I hope this tool is still helpful in game implementation where data persisence
# needs fit perfectly with this tool

# You can make a DataDict, which is a Key Value Pair dictionary
	# add, update, remove, save
# You can add Objects to Persistent Objects, which is a dictionary, and these will save
# automatically

# For scene reloading for example, any object is saved, and the current_scene is saved
# And you would simply reload the current scene, and the state of the current entities

# Users when developing games tend to save:
# - whole objects, or specific properties of objects
# - lists of integers or floats that represent a multitude of states, or values from a multitude of objects
# - specific fields that are uncategorized, and are better off as key value pairs

# User when developing games reload data, and require:
# - objects to be reinstantiated as whole, or with specific properties
# - lists of integers or floats spread across a multitude of specific objects, or values
#	- ui needs to be filled out generally
# 	- profile data needs to be filled out
# essentially, there needs to be a `_data_injection` phase

static var main_loop = Engine.get_main_loop()
static var scene_root = main_loop.get_root()

static var path = "user://Data"
static var delimiter = "~"

static var data = { # :Dictionary[String:DataDict]
	"test":"test"
}

# Different ways to represent an object, or value

# key value pairs vs object serialization
# i.e.
# store declarative names and values vs store whole objects
# both are valuable and useful, there needs to be a gentle balance between both

# files need to be optionally easily readable, and interactable
# files elsewise will be written in binary format

static var types_representation = { # :Dictionary[String, int]
}

# This holds the Object itself as a key, and the value is either
static var persistent_objects = { # :Dictionary[Object, Array[String]]
}


func _ready() -> void:
	print("Loading Data Persistence")
	for type_value in range(Variant.Type.TYPE_NIL, Variant.Type.TYPE_MAX):
		var type_string = type_string(type_value)
		if type_string != "":
			types_representation[type_string] = type_value
	if !DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_absolute(path)
	check_for_existing_data_dicts()
	print("Data Persistence Loaded")


func check_for_existing_data_dicts() -> Variant:
	for file in DirAccess.get_files_at(path):
		var data_dict_name = file.split(".")[0]
		var data_dict = new_data_dict(data_dict_name)
		data_dict.load_from_file()
	return


static func data_dict_exists(dict_name:String) -> bool:
	if dict_name in data.keys():
		return true
	return false


static func save_all() -> void:
	for data_dict in data:
		data_dict.save()


static func new_data_dict(dict_name:String) -> Variant:
	if dict_name in data.keys():
		return
	data[dict_name] = DataDict.new(dict_name)
	return data[dict_name]
