extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 50
var player = null

func _physics_process(delta: float) -> void:
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()
		anim.play("Walk")
		anim.flip_h = dir.x < 0
	else:
		velocity = Vector2(0,0)
		anim.play("Idle")

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player = null


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body.name == "hit_box":
		pass
