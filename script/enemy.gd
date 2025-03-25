extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
@onready var hp_bar = $"hp-bar"
@onready var anim_damage = $Node2D/AnimaDamage
@onready var hp_damage = $Node2D/hp
var speed = 50
var player = null
var can_move = true
var death = false
var player_in = false
var health = 100
var show_damage = false
var already_dead = false

func _physics_process(delta: float) -> void:
	hp_damage.visible = false
	hp_bar.value = health
	if health == 100:
		hp_bar.visible = false
	else: 
		hp_bar.visible = true
	
	# Обновляем данные слайма в глобальном массиве
	update_slime_data()
		
	if health <= 0 and not already_dead:
		already_dead = true  # Отмечаем, что смерть уже обработана
		hp_bar.visible = false
		death = true
		Global.slime_killed += 1  # Теперь это выполнится только один раз
		die()
		return 
	
	if show_damage == true:
		hp_damage.visible = true
		anim_damage.play("hp_minus")
		hp_damage.text = "-" + str(Global.damage_to_display)
		
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

# Добавляем новую функцию для обновления данных
func update_slime_data():
	# Найдем этого слайма в массиве по его позиции
	var found = false
	for i in range(Global.slime_data.size()):
		# Используем приблизительное сравнение, так как позиция может немного меняться
		if Global.slime_data[i].position.distance_to(position) < 10:
			# Обновляем данные
			Global.slime_data[i].health = health
			Global.slime_data[i].position = position
			found = true
			break
	
	# Если не нашли, добавляем нового слайма
	if not found:
		Global.slime_data.append({
			"position": position,
			"health": health
		})

func die():
	can_move = false
	health = 0
	set_physics_process(false)
	# Удаляем данные о слайме
	remove_slime_data()
	animP.play("Death")
	await animP.animation_finished
	queue_free()

# Добавляем функцию для удаления данных о слайме
func remove_slime_data():
	for i in range(Global.slime_data.size()):
		if Global.slime_data[i].position.distance_to(position) < 10:
			Global.slime_data.remove_at(i)
			break
		
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
		velocity = Vector2.ZERO
		can_move = false
		animP.play("Attack")
		await animP.animation_finished
		can_move = true
		
func take_damage():
	health -= Global.player_damage  # Уменьшаем здоровье на величину урона
	print(health)
	show_damage = true
	await get_tree().create_timer(1).timeout
	show_damage = false
	if health <= 0:
		Global.slime_count -= 1
	
func shaking_true():
	Global.damage = true
	
func shaking_false():
	Global.damage = false
