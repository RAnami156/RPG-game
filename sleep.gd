extends Node2D

func _physics_process(delta: float) -> void:
	var timer = get_tree().create_timer(3)
	timer.timeout.connect(func():
		Global.animation_position = 17.0
		get_tree().change_scene_to_file("res://scene/house.tscn")
	)
	set_physics_process(false)  # Stop calling _physics_process
