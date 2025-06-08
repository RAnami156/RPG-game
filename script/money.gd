extends Node2D

@onready var animP = $AnimationPlayer

func _ready() -> void:
	animP.play("default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" :
		Global.player_money += 1
		animP.play("up")
		await animP.animation_finished
		queue_free()
		print(Global.player_money)
