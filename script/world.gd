extends Node2D

@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time

var days_count = -1
var time_count
var slime_preload = preload("res://scene/enemy.tscn")

func _process(delta: float) -> void:
	if Global.player_healht <= 0 :
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

func _on_timer_timeout() -> void:
	slime_spawn()
	
func slime_spawn():
	var slime = slime_preload.instantiate()
	slime.position = Vector2(randf_range(200, 400), randf_range(250, 375))
	$enemys.add_child(slime)
