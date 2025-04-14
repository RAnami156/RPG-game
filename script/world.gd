extends Node2D
@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time
@onready var player = $player
@onready var enemys = $enemys
var house = false
var slime_preload = preload("res://scene/enemy.tscn")
var last_position = 0 

func _ready():
	print("day:", Global.days_count)
	load_slimes()
	
	animP.play("day-night")
	animP.seek(Global.animation_position)
	last_position = Global.animation_position 
	

func _process(delta: float) -> void: 
	#print(Global.slime_killed)
	#print(Global.stamina)
	#print(Global.days_count)
	#print(Global.animation_position)
	if Global.player_healht <= 0:
		animP.stop()
	else:
		animP.play("day-night")
			
		# Проверяем, был ли переход от конца к началу анимации
		if animP.current_animation_position < last_position:
			Global.days_count += 1 # Увеличиваем счетчик дней когда анимация перезапустилась
		
		# Сохраняем текущую позицию для следующего кадра
		last_position = animP.current_animation_position
		
		# Сохраняем текущую позицию анимации в Global
		Global.animation_position = animP.current_animation_position
		days.text = str(Global.days_count) + " DAY"
		time.text = "time: "  + str(int(Global.animation_position)) + "h" + " (" + str(Global.time_count) + ")"
		
	if house:
		$outside.visible = true
	else:
		$outside.visible = false
		
	if house and Input.is_action_just_pressed("E") :
		get_tree().change_scene_to_file("res://scene/house.tscn")
		Global.current_scene = "res://scene/house.tscn"
		Global.player_position = Vector2(128,88)

 #DAYS
func day():
	Global.time_count = "day"
	
func evening():
	Global.time_count = "evening"
	
func night():
	Global.time_count = "night"
	
func morning():
	Global.time_count= "morning" 
	
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
		if slime.health == 0:
			Global.slime_killed += 1 


func _on_house_body_entered(body: Node2D) -> void:
	if body.name == "player":
		house = true
		
func _on_house_body_exited(body: Node2D) -> void:
	if body.name == "player":
		house = false
