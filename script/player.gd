extends CharacterBody2D


@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
@onready var hp_bar = $"CanvasLayer/hp-bar"
@onready var stamina_bar = $CanvasLayer/stamina
@onready var text_slime_killed = $CanvasLayer/slime_killed


enum Dir { DOWN, UP, LEFT, RIGHT }

var idle_dir = Dir.DOWN
var can_move = true
var crit_chance = 0.15
var is_paused = false

var speed = 100 
var max_stamina = 100
var stamina_minus = 30  
var stamina_regen = 10  

var heal_amount = 2        
var heal_interval = 1      
var max_health = 100       
var is_healing = false

func _ready() -> void:
	Engine.time_scale = 1
	$CanvasLayer/pause.visible = false
	position = Global.player_position

func _physics_process(delta: float) -> void:
	print(Global.animation_position)
	$CanvasLayer/hp_text.text = str(Global.player_healht)
	
	#BUTTONS
	if Input.is_action_just_pressed("esc"):
		is_paused = !is_paused  # Переключаем паузу
		Engine.time_scale = 0 if is_paused else 1
		$CanvasLayer/pause.visible = is_paused
		can_move = not is_paused
	if Global.resume:
		is_paused = false
		can_move = true
		$CanvasLayer/pause.visible = false  # Скрываем меню паузы
		Engine.time_scale = 1  # Возвращаем нормальную скорость времени
		Global.resume = false
	if Global.save:
		save_game()
	if Global.load:
		load_game()


	$CanvasLayer/speed.text = str(speed)
	$"CanvasLayer/stanima-text".text = str(Global.stamina)
	text_slime_killed.text = "slime killed: " + str(Global.slime_killed)
	
	run(delta)
	await healing()
	
	stamina_bar.value = Global.stamina
	hp_bar.value = Global.player_healht
	if Global.player_healht <= 0:
		Global.player_healht = 0
		animP.play("Death")
		await animP.animation_finished
		self.queue_free()
		Global.end = true
		
	if is_healing == true:
		$Health_plus.visible = true
	else:
		$Health_plus.visible = false
		
	if !can_move:
		return
	
	if Input.is_action_just_pressed("attack"):
		attack()
	elif Input.is_action_pressed("up"):
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
	#Global.is_paused = is_paused
	Global.player_position = position

func run(delta):
	if Input.is_action_pressed("run") and Global.stamina > 0:
		speed = 150
		Global.stamina -= stamina_minus * delta
		if Global.stamina <= 0:	
			Global.stamina = 0
			speed = 100 
			
	else:
		speed = 100
		Global.stamina += stamina_regen * delta
		if Global.stamina >= max_stamina:
			Global.stamina = max_stamina
			

func healing():
	if is_healing:
		return 
	is_healing = true
	
	while Global.player_healht < max_health:
		animP.play("health")
		await get_tree().create_timer(heal_interval).timeout
		Global.player_healht += heal_amount
		#print(Global.player_healht)
		if Global.player_healht > max_health:
			Global.player_healht = max_health
		hp_bar.value = Global.player_healht
	
	is_healing = false  # Останавливаем, когда HP полное

func up_move():
	anim.play("Up")
	velocity = Vector2(0, -speed)
	idle_dir = Dir.UP
	
func down_move():
	anim.play("Down")
	velocity = Vector2(0, speed)
	idle_dir = Dir.DOWN
	
func left_move():
	anim.flip_h = true
	anim.play("Front")
	velocity = Vector2(-speed, 0)
	idle_dir = Dir.LEFT
	
func right_move():
	anim.flip_h = false
	anim.play("Front")
	velocity = Vector2(speed, 0)
	idle_dir = Dir.RIGHT
	
func idle():
	velocity = Vector2.ZERO
	if velocity == Vector2.ZERO:
		match idle_dir:
			Dir.DOWN:
				anim.play("Idle_down")
			Dir.UP:
				anim.play("Idle_up")
			Dir.LEFT:
				anim.flip_h = true
				anim.play("Idle_front")
			Dir.RIGHT:
				anim.flip_h = false
				anim.play("Idle_front")
				
func attack():
	velocity = Vector2.ZERO
	can_move = false
	if velocity == Vector2.ZERO:
		match idle_dir:
			Dir.DOWN:
				animP.play("Attack_down")
			Dir.UP:
				animP.play("Attack_up")
			Dir.LEFT:
				anim.flip_h = true
				animP.play("attack_left")
			Dir.RIGHT:
				anim.flip_h = false
				animP.play("Attack_right")
				
	await anim.animation_finished
	can_move = true

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		var is_crit = randf() < crit_chance 
		var original_damage = Global.player_damage  
		
		Global.player_damage *= 2 if is_crit else 1  
		body.take_damage()
		
		var damage_to_display = Global.player_damage
		
		print("enemy -20 "," (Крит!)" if is_crit else "")
		
		await get_tree().process_frame 
		Global.player_damage = original_damage  
		
		Global.damage_to_display = damage_to_display

func _on_hit_box_body_exited(body: Node2D) -> void:
	pass
	
# SAVE
var save_path = "user://savegame.save"

func save_game():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	
	file.store_var(Global.days_count)
	file.store_var(position.x)
	file.store_var(position.y)
	file.store_var(Global.animation_position)
	#file.store_var(Global.player_healht)
	#file.store_var(Global.stamina)
	
	Global.save = false

func load_game():
	var file = FileAccess.open(save_path,FileAccess.READ)
	
	Global.days_count = file.get_var(Global.days_count)
	position.x = file.get_var(position.x)
	position.y = file.get_var(position.y)
	Global.animation_position = file.get_var(Global.animation_position)
	#Global.player_healht = file.get_var(Global.player_healht)
	#Global.stamina = file.get_var(Global.stamina)
	
	Global.load = false
