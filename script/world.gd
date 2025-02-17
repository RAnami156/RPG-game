extends Node2D

@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time
var days_count = -1
var time_count

func _process(delta: float) -> void:
	if Global.player_healht <= 0 :
		animP.stop()
	else:
		animP.play("day-night")
		days.text = str(days_count) + " DAY"
		time.text = "time: " + str(time_count)


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
