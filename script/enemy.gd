extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
@onready var hp_bar = $"hp-bar"
var speed = 50
var player = null
var can_move = true
var death = false
var player_in = false

func _physics_process(delta: float) -> void:
	hp_bar.value = Global.enemy_health
	
	if Global.enemy_health <= 0:
		hp_bar.visible = false
		death = true
		die()
		return

	if death:
		animP.stop()
		
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

func die():
	can_move = false
	Global.enemy_health = 0  
	animP.play("Death")
	await animP.animation_finished
	queue_free()  

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body

func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player = null

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.player_healht -= 40
		print("player ", Global.player_healht)
		
	


func _on_damagezone_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in = true
		attack()

func _on_damagezone_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in = false
		

func attack():
	while player_in:
		#Global.damage = true
		#print(Global.damage)
		velocity = Vector2.ZERO
		can_move = false
		animP.play("Attack")
		await animP.animation_finished
		#Global.damage = false
		can_move = true
		
func  shaking_true():
	Global.damage = true
	
func  shaking_false():
	Global.damage = false
