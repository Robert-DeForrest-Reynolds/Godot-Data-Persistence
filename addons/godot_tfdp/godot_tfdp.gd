@tool
extends EditorPlugin

var Debug = false

# Replace this value with a PascalCase autoload name, as per the GDScript style guide.
const GLOBAL_NAME = "Data"


func _enable_plugin():
	add_autoload_singleton(GLOBAL_NAME, "res://addons/godot_tfdp/Data.gd")


func _disable_plugin():
	remove_autoload_singleton(GLOBAL_NAME)


func _init() -> void:
	print("Initializing Text File Data Persistence")


func _enter_tree() -> void:
	print("Plugin loaded")


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
