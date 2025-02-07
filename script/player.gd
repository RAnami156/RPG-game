extends CharacterBody2D

enum {
	DOWN,
	UP,
	LEFT,
	RIGHT
}

@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
var speed = 100
var idle_dir = DOWN
var can_move = true

func _physics_process(delta: float) -> void:
	if Global.player_healht <= 0:
		Global.player_healht = 0
		animP.play("Death")
		await  animP.animation_finished
		self.queue_free()
		Global.end = true
	
	if !can_move:
		return
	
	run()
	if Input.is_action_just_pressed("attack"):
		attack()
	elif  Input.is_action_pressed("up") :
		up_move()
	elif Input.is_action_pressed("down"):
		down_move()
	elif Input.is_action_pressed("left"):
		left_move()
	elif Input.is_action_pressed("right"):
		right_move()
	else:
		idle()
		
	move_and_slide()
		
func run():
	if Input.is_action_pressed("run"):
		speed = 200
	else:
		speed = 100

func up_move():
	anim.play("Up")
	velocity = Vector2(0, -speed)
	idle_dir = UP
	
func down_move():
	anim.play("Down")
	velocity = Vector2(0, speed)
	idle_dir = DOWN
	
func left_move():
	anim.flip_h = true
	anim.play("Front")
	velocity = Vector2(-speed, 0)
	idle_dir = LEFT
	
func right_move():
	anim.flip_h = false
	anim.play("Front")
	velocity = Vector2(speed, 0)
	idle_dir = RIGHT
	
func idle():
	velocity = Vector2.ZERO
	if velocity == Vector2.ZERO:
		match idle_dir:
			DOWN:
				anim.play("Idle_down")
			UP:
				anim.play("Idle_up")
			LEFT:
				anim.flip_h = true
				anim.play("Idle_front")
			RIGHT:
				anim.flip_h = false
				anim.play("Idle_front")
				
func attack():
	velocity =Vector2.ZERO
	can_move = false
	if velocity == Vector2.ZERO:
		match idle_dir:
			DOWN:
				animP.play("Attack_down")
			UP:
				animP.play("Attack_up")
			LEFT:
				anim.flip_h = true
				animP.play("attack_left")
			RIGHT:
				anim.flip_h = false
				animP.play("Attack_right")
				
	await anim.animation_finished
	can_move = true


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.name == "enemy":
		Global.enemy_health -= 20
		print("enemy ",Global.enemy_health)
