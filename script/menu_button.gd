extends Button

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://scene/menu.tscn")

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")
	#Global.slime_count = 0
