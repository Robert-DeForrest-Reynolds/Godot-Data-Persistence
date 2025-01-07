class_name Error


func _init(error_message:String, fail_fast=false) -> void:
	if fail_fast == true:
		error_message += "\n\nCrashing Application to Avoid Corruption"
	OS.alert(error_message, "Data Persistence Error")
	if fail_fast == true:
		Data.scene_root.quit()
