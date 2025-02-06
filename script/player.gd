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
	var shake_strength = Vector2(randf_range(-2, 2), randf_range(-2, 2))
	$Camera2D.offset = shake_strength
	if Input.is_action_pressed("run"):
		speed = 200
	else:
		speed = 100

func up_move():
	$Camera2D.offset = Vector2.ZERO
	anim.play("Up")
	velocity = Vector2(0, -speed)
	idle_dir = UP
	
func down_move():
	$Camera2D.offset = Vector2.ZERO
	anim.play("Down")
	velocity = Vector2(0, speed)
	idle_dir = DOWN
	
func left_move():
	$Camera2D.offset = Vector2.ZERO
	anim.flip_h = true
	anim.play("Front")
	velocity = Vector2(-speed, 0)
	idle_dir = LEFT
	
func right_move():
	$Camera2D.offset = Vector2.ZERO
	anim.flip_h = false
	anim.play("Front")
	velocity = Vector2(speed, 0)
	idle_dir = RIGHT
	
func idle():
	$Camera2D.offset = Vector2.ZERO
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
	$Camera2D.offset = Vector2.ZERO
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
		print(Global.enemy_health)
