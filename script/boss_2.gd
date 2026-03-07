extends CharacterBody2D

@export var speed = 30
@export var damage = 20
@export var attack_cooldown = 1.0
@export var max_health = 300
@export var slime_spawn_interval = 5.0
@export var max_slimes = 4
@export var spawn_radius = 80.0
@export var laser_interval = 8.0
@export var laser_count = 8
@export var laser_damage = 15
@export var laser_warning_time = 1.2

@onready var anim = $AnimatedSprite2D

var health = max_health
var is_dead = false
var player = null
var chasing = false
var player_in_damagezone = false
var can_attack = true
var is_attacking = false
var is_looping = false
var slime_preload = preload("res://scene/enemy.tscn")
var laser_preload = preload("res://scene/laser_bullet.tscn")
var warning_preload = preload("res://scene/laser_warning.tscn")
var spawned_slimes = []

func _ready() -> void:
	spawn_loop()
	laser_loop()

func _physics_process(_delta) -> void:
	$CanvasLayer/TextureProgressBar.value = health

	if is_dead:
		return

	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if chasing and player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		anim.play("Idle")
	else:
		velocity = Vector2.ZERO
		anim.play("Idle")

	move_and_slide()

# ======================
# ДЕТЕКТОР ПРЕСЛЕДОВАНИЯ
# ======================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		chasing = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		chasing = false

# ======================
# ЗОНА АТАКИ (DAMAG-ZONE)
# ======================
func _on_damagezone_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_damagezone = true
		if not is_looping and not is_dead:
			attack_loop()

func _on_damagezone_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_damagezone = false

func attack_loop() -> void:
	is_looping = true

	while player_in_damagezone and not is_dead:
		is_attacking = true

		anim.play("attack")
		await anim.animation_finished

		if player_in_damagezone and player != null:
			Global.player_healht -= damage
			print("Player HP: ", Global.player_healht)

		is_attacking = false

		await get_tree().create_timer(attack_cooldown).timeout

	is_looping = false

# ======================
# ЛАЗЕРЫ (снаряды по кругу)
# ======================
func laser_loop() -> void:
	while not is_dead:
		await get_tree().create_timer(laser_interval).timeout

		if is_dead:
			break

		if chasing:
			await show_warnings()
			shoot_lasers()

func show_warnings() -> void:
	for i in laser_count:
		var angle = (TAU / laser_count) * i
		var dir = Vector2(cos(angle), sin(angle))

		var warning = warning_preload.instantiate()
		warning.global_position = global_position
		get_parent().add_child(warning)
		warning.setup(dir)

	await get_tree().create_timer(laser_warning_time).timeout

func shoot_lasers() -> void:
	for i in laser_count:
		var angle = (TAU / laser_count) * i
		var dir = Vector2(cos(angle), sin(angle))

		var bullet = laser_preload.instantiate()
		bullet.direction = dir
		bullet.damage = laser_damage
		bullet.global_position = global_position
		get_parent().add_child(bullet)

# ======================
# СПАВН СЛАЙМОВ
# ======================
func spawn_loop() -> void:
	while not is_dead:
		await get_tree().create_timer(slime_spawn_interval).timeout

		if is_dead:
			break

		spawned_slimes = spawned_slimes.filter(func(s): return is_instance_valid(s))

		if spawned_slimes.size() < max_slimes and chasing:
			spawn_slime()

func spawn_slime() -> void:
	var slime = slime_preload.instantiate()

	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * (spawn_radius * randf_range(0.5, 1.0))

	slime.global_position = global_position + offset
	get_parent().add_child(slime)
	spawned_slimes.append(slime)

# ======================
# ПОЛУЧЕНИЕ УРОНА
# ======================
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_attack"):
		take_damage()

func take_damage():
	if is_dead:
		return

	health -= Global.player_damage
	print("Boss HP: ", health)

	if health <= 0:
		die()

# ======================
# СМЕРТЬ
# ======================
func die():
	is_dead = true
	player_in_damagezone = false
	chasing = false
	is_looping = false
	is_attacking = false
	velocity = Vector2.ZERO
	set_physics_process(false)

	for slime in spawned_slimes:
		if is_instance_valid(slime):
			slime.queue_free()
	spawned_slimes.clear()

	anim.play("Idle")

	await get_tree().create_timer(0.5).timeout
	queue_free()
