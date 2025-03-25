extends Control


func _on_resum_pressed() -> void:
	Global.resume = true
	#Global.is_paused = false


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")
