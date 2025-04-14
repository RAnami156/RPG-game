extends Node2D

func _ready() -> void:
	Engine.time_scale = 1

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("Idle_down")
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file(Global.current_scene)

func _on_exit_pressed() -> void:

	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(Global.current_scene)
