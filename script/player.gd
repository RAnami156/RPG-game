extends CharacterBody2D

enum Direction {RIGHT, DOWN, LEFT, UP}

@export_category("Node")
@export var sprite: AnimatedSprite2D
@export var animation: AnimationPlayer
@export var health_bar: Range
@export var stamina_bar: Range
@export var speed_label: Label
@export var stamina_label: Label
@export var heal_timer: Timer # Включить таймер в редакторе (autostart = true)

@export_category("Movement")
@export var walking_speed: float = 2500
@export var run_speed: float = 3500
@export var max_speed: float = 3500
@export var max_stamina: float = 100
@export var stamina_cost: float = 30
@export var stamina_heal: float = 10

@export_category("Health")
@export var damage: float = 20
@export var critical_damage_chance: float = 0.15
@export var heal_amount: float = 2
@export var max_health: float = 100

var can_move: bool = true
var is_healing: bool = false
var current_health: float: set = _set_current_health
var current_speed: float: set = _set_current_speed
var current_stamina: float: set = _set_current_stamina

var current_direction: Direction = Direction.DOWN: set = _set_current_direction
var input_direction: Vector2 = Vector2.ZERO: set = _set_input_direction

func _ready() -> void:
	current_health = max_health
	current_stamina = max_stamina
	current_speed = walking_speed

	heal_timer.timeout.connect(heal)

	# Бесполезное присвоение локальной позиции игрока
	# position = Global.player_position

func _process(_delta: float) -> void:
	# Вызываем обработку передвижения персонажа (Проверяет коллизии, использует velocity в качестве параметра добавляющего вектора движения)
	move_and_slide()

func _physics_process(delta: float) -> void:
	handler_movement(delta)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and can_move:
		attack()

func attack() -> void:
	print("Attack")
	velocity = Vector2.ZERO
	can_move = false

	match current_direction:
		Direction.RIGHT:
			sprite.flip_h = false
			animation.play("Attack_right")
		
		Direction.DOWN:
			animation.play("Attack_down")
		
		Direction.LEFT:
			sprite.flip_h = true
			animation.play("attack_left")
		
		Direction.UP:
			animation.play("Attack_up")
	
	# Тут можно написать через подключение окончания анимации, но это более длинно и сейчас данный код будет более читаемым
	# Однако в будущем стоит заменить на отдельную функцию (animation.connect(animation_finished, ...))
	await animation.animation_finished
	can_move = true

func update_animation() -> void:
	if input_direction != Vector2.ZERO:
		match current_direction:
			Direction.RIGHT:
				sprite.flip_h = false
				sprite.play("Front")
			
			Direction.DOWN:
				sprite.play("Down")
			
			Direction.LEFT:
				sprite.flip_h = true
				sprite.play("Front")
		
			Direction.UP:
				sprite.play("Up")
	else:
		match current_direction:
			Direction.RIGHT:
				sprite.flip_h = false
				sprite.play("Idle_front")
			
			Direction.DOWN:
				sprite.play("Idle_down")
			
			Direction.LEFT:
				sprite.flip_h = true
				sprite.play("Idle_front")
		
			Direction.UP:
				sprite.play("Idle_up")

func handler_movement(delta: float) -> void:
	if !can_move: return

	velocity = input_direction * current_speed * delta

	# Используем стандарт по движению персонажа
	input_direction = Input.get_vector("left", "right", "up", "down")

	handler_run(delta)

func handler_run(delta: float) -> void:
	if !Input.is_action_pressed("run") or current_stamina <= 0:
		current_stamina += stamina_heal * delta
		current_speed = walking_speed
		return

	current_speed = run_speed
	current_stamina -= stamina_cost * delta

func heal() -> void:
	if current_health == max_health:
		return
	
	current_health += heal_amount
	current_health = clampf(current_health, 0, max_health)

func take_damage(give_damage: float) -> void:
	current_health -= give_damage
	if current_health <= 0:
		death()

func death() -> void:
	print("You died")
	process_mode = Node.PROCESS_MODE_DISABLED
	process_priority = -1

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		var is_critical = randf() < critical_damage_chance
		var original_damage = damage
		
		damage *= 2 if is_critical else 1
		body.take_damage(damage)
		
		var damage_to_display = damage
		
		print("enemy -20 ", " (Крит!)" if is_critical else "")
		
		await get_tree().process_frame
		damage = original_damage
		
		Global.damage_to_display = damage_to_display

func _set_current_direction(value: Direction) -> void:
	current_direction = value

	update_animation()
			
func _set_input_direction(value: Vector2) -> void:
	input_direction = value

	if value != Vector2.ZERO:
		# Получаем угол между оси X и Y
		var angle = roundf(input_direction.angle())

		if angle == 0:
			current_direction = Direction.RIGHT
		elif angle == 1 or angle == 2:
			current_direction = Direction.DOWN
		elif angle == 3:
			current_direction = Direction.LEFT
		elif angle < 0:
			current_direction = Direction.UP
	else:
		update_animation()
	
	# print("current_direction: ", current_direction, "\n", "input_direction: ", input_direction, "\n", "angle: ", angle)

func _set_current_health(value: float) -> void:
	value = clampf(value, 0, max_health)

	current_health = value
	health_bar.value = value / health_bar.max_value * health_bar.max_value

func _set_current_stamina(value: float) -> void:
	value = clampf(value, 0, max_stamina)

	current_stamina = value
	stamina_label.text = str(value)
	stamina_bar.value = value / stamina_bar.max_value * stamina_bar.max_value

func _set_current_speed(value: float) -> void:
	value = clampf(value, 0, max_speed)

	current_speed = value
	speed_label.text = str(value)
