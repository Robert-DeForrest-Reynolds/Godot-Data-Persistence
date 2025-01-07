@tool
extends EditorPlugin

const DataDock = preload("res://addons/godot_data_persistence/DataDock.tscn")
const DataLabel = preload("res://addons/godot_data_persistence/DataLabel.tscn")

var Debug = false
var data_dock:PanelContainer
var data_dict_list:ItemList
var contents:VBoxContainer
var icon

# Replace this value with a PascalCase autoload name, as per the GDScript style guide.
const GLOBAL_NAME = "Data"


func _disable_plugin():
	if data_dock:
		data_dock.queue_free()


func _init() -> void:
	print("Initializing Text File Data Persistence")
	var loaded_icon = load("res://addons/godot_data_persistence/pineapple.png")
	var icon_image = Image.new()
	icon_image = loaded_icon.get_image()
	icon_image.resize(24, 20, Image.INTERPOLATE_LANCZOS)
	icon = ImageTexture.create_from_image(icon_image)


func _has_main_screen():
	return true


func _make_visible(visible):
	if data_dock:
		data_dock.visible = visible


func _get_plugin_name():
	return "View Data"


func _get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return icon


func _enter_tree() -> void:
	print("Data Persistence loaded")
	data_dock = DataDock.instantiate()
	data_dict_list = data_dock.get_node("%DataDicts")
	contents = data_dock.get_node("%Contents")
	data_dock.get_node("%LoadData").pressed.connect(load_data)
	data_dict_list.item_selected.connect(load_file_fields)
	EditorInterface.get_editor_main_screen().add_child(data_dock)
	_make_visible(false)


func _exit_tree() -> void:
	if data_dock:
		data_dock.queue_free()


func load_data():
	data_dict_list.clear()
	for file in DirAccess.get_files_at("user://Data"):
		data_dict_list.add_item(file.split(".txt")[0])


func load_file_fields(selection_index:int):
	for child in contents.get_children():
		child.free()
	var file_name = data_dict_list.get_selected_items()[0]
	file_name = data_dict_list.get_item_text(file_name)
	var file = FileAccess.open("user://Data/" + file_name + ".txt", FileAccess.READ)
	for line in file.get_as_text().split("\n"):
		if line == "":continue
		var h_box = HBoxContainer.new()
		contents.add_child(h_box)
		var line_data = line.split("~")
		var new_label = DataLabel.instantiate()
		new_label.text = line_data[0]
		h_box.add_child(new_label)
		if line_data[2] == "int":
			var new_spin_box = SpinBox.new()
			new_spin_box.value = int(line_data[1])
			h_box.add_child(new_spin_box)
