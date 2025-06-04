extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer

var speed = 50
var player = null
var can_move = true
var death = false
var player_in = false
var show_damage = false
var already_dead = false

func _physics_process(delta: float) -> void:
	if !can_move:
		return
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()
		animP.play("Walk")
		anim.flip_h = dir.x < 0
	else:
		velocity = Vector2.ZERO
		anim.play("Idle")

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body

func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player = null

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.player_healht -= 80
		print("player ", Global.player_healht)
		
func _on_damagezone_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in = true
		attack()

func _on_damagezone_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in = false
		
func attack():
	velocity = Vector2.ZERO
	can_move = false
	animP.play("Attack")
	await animP.animation_finished
	can_move = true
	queue_free()

func shaking_true():
	Global.damage = true
	
func shaking_false():
	Global.damage = false
