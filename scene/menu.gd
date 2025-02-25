extends Node2D


func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.play("Idle_down")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/world.tscn")
