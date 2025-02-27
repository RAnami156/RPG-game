extends Node2D

@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time
@onready var player = $player
@onready var enemys = $enemys

var time_count
var slime_preload = preload("res://scene/enemy.tscn")

func _ready():
	load_slimes()

func _process(delta: float) -> void: 
	#print(Global.slime_positions)
	if Global.player_healht <= 0:
		animP.stop()
	else:
		animP.play("day-night")
		days.text = str(Global.days_count) + " DAY"
		time.text = "time: " + str(time_count)

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
		Global.slime_positions.append(slime.position)  # Сохраняем позицию
		print("Slime spawned at:", slime.position)

func load_slimes():
	# Загружаем слаймов из сохранённых позиций
	for pos in Global.slime_positions:
		var slime = slime_preload.instantiate()
		slime.position = pos
		enemys.add_child(slime)
		print("Loaded slime at:", slime.position)
