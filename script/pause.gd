extends Control


func _on_resum_pressed() -> void:
	Global.resume = true
	#Global.is_paused = false


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")


func _on_save_pressed() -> void:
	Global.save = true


func _on_load_pressed() -> void:
	Global.load = true
