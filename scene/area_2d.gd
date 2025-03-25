extends Area2D

@onready var text = $Label
var player_in = false

func _physics_process(delta: float) -> void:
	if player_in:
		text.visible = true
	else:
		text.visible = false
	if player_in and Global.slime_killed >= 2:
		text.text = "Press E to fight boss"
	else:
		text.text = "Kill 10 slides to fight the boss"
	if player_in and Global.slime_killed >= 2 and Input.is_action_just_pressed("E"):
		get_tree().change_scene_to_file("res://scene/boss_level.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in = false
