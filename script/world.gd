extends Node2D
@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time
@onready var player = $player
@onready var enemys = $enemys
var time_count = "day"
var slime_preload = preload("res://scene/enemy.tscn")

func _ready():
	print("day:", Global.days_count)
	load_slimes()
	# Загружаем и устанавливаем позицию анимации
	
	animP.play("day-night")
	animP.seek(Global.animation_position)

func _process(delta: float) -> void: 
	#print(Global.animation_position)
	if Global.player_healht <= 0:
		animP.stop()
	else:
		if !animP.is_playing():
			animP.play("day-night")
		if Global.animation_position == 0:
			Global.days_count += 1
		# Сохраняем текущую позицию анимации
		Global.animation_position = animP.current_animation_position
		
		days.text = str(Global.days_count) + " DAY"
		time.text = "time: "  + str(int(Global.animation_position)) + "h" + " (" + str(time_count) + ")"


# DAYS
func day_plus():
	Global.days_count += 1 
	
func day():
	time_count = "day"
	
func evening():
	time_count = "evening"
	
func night():
	time_count = "night"
	
func morning():
	time_count = "morning" 
	
func slime_spawn():
	if Global.slime_count >= 3:
		print("Slime spawn limit reached")
		return
	
	var spawn_amount = min(3 - Global.slime_count, 3)
	for i in range(spawn_amount):
		var slime = slime_preload.instantiate()
		slime.position = Vector2(randf_range(0, 375), randf_range(200, 645))
		enemys.add_child(slime)
		Global.slime_count += 1
		
		# Добавляем информацию о новом слайме
		Global.slime_data.append({
			"position": slime.position,
			"health": 100  # Начальное здоровье слайма
		})
		
		print("Slime spawned at:", slime.position)
		
func load_slimes():
	# Загружаем слаймов из сохранённых данных
	for slime_info in Global.slime_data:
		var slime = slime_preload.instantiate()
		slime.position = slime_info.position
		slime.health = slime_info.health  # Устанавливаем сохраненное здоровье
		enemys.add_child(slime)
		print("Loaded slime at:", slime.position, "with health:", slime.health)
