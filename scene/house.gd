extends Node2D

var ouside = false

func _physics_process(delta: float) -> void:
	if ouside:
		$outside.visible = true
	else:
		$outside.visible = false
	if ouside  and Input.is_action_just_pressed("E"):
		get_tree().change_scene_to_file("res://scene/world.tscn")
		Global.player_position = Vector2(555,261)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		ouside = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		ouside = false
