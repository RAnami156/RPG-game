extends Node2D

func _physics_process(delta: float) -> void:
	await  get_tree().create_timer(3).timeout
	Global.animation_position = 17.0 
	get_tree().change_scene_to_file("res://scene/house.tscn")
