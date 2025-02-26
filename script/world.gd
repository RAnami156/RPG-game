extends Node2D

@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time

var days_count = -1
var time_count
var slime_preload = preload("res://scene/enemy.tscn")

func _process(delta: float) -> void:
	#slime_spawn()
	if Global.player_healht <= 0:
		animP.stop()
	else:
		animP.play("day-night")
		days.text = str(days_count) + " DAY"
		time.text = "time: " + str(time_count)

#DAYS
func day_plus():
	days_count += 1 
	
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
	
	var spawn_amount = min(3 - Global.slime_count, 3)  # Чтобы не превысить лимит
	for i in range(spawn_amount):
		var slime = slime_preload.instantiate()
		slime.position = Vector2(randf_range(0, 375), randf_range(200, 645))
		$enemys.add_child(slime)
		Global.slime_count += 1  # Увеличиваем счетчик слаймов
		print("Slime spawned at:", slime.position)
