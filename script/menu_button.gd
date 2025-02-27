extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")
	#Global.slime_count = 0
