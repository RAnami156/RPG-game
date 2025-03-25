extends Node2D

@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time
@onready var bed_text = $bed
var last_position = 0 
var ouside = false
var bed = false
var can_sleep = false

func _ready():
	animP.play("day-night")
	animP.seek(Global.animation_position)
	last_position = Global.animation_position 
	

func _physics_process(delta: float) -> void:
	#print(Global.days_count)
	#print(Global.animation_position)
	animP.play("day-night")
			
	# Проверяем, был ли переход от конца к началу анимации
	if animP.current_animation_position < last_position:
		Global.days_count += 1 # Увеличиваем счетчик дней когда анимация перезапустилась
		
	# Сохраняем текущую позицию для следующего кадра
	last_position = animP.current_animation_position
		
		# Сохраняем текущую позицию анимации в Global
	Global.animation_position = animP.current_animation_position
	
	$dayss.text = str(Global.days_count) + " DAY"
	time.text = "time: "  + str(int(Global.animation_position)) + "h" + " (" + str(Global.time_count) + ")"
	
	
	
	if ouside:
		$outside.visible = true
	else:
		$outside.visible = false
	if ouside  and Input.is_action_just_pressed("E"):
		get_tree().change_scene_to_file("res://scene/world.tscn")
		Global.current_scene = "res://scene/world.tscn"
		Global.player_position = Vector2(555,261)
		
	#SLEEP AND BED
	if bed:
		bed_text.visible = true
	else:
		bed_text.visible = false
	
	if can_sleep:
		bed_text.text = "Press 'E' to sleep"
	else:
		bed_text.text = "You can only sleep at night"
	
	if Global.animation_position > 7 and Global.animation_position < 16:
		can_sleep = true
	else:
		can_sleep = false
		
	if can_sleep and Input.is_action_just_pressed("E"):
		#Global.animation_position = 17.0
		#animP.stop()
		get_tree().change_scene_to_file("res://scene/sleep.tscn")
		print("rav lox")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		ouside = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		ouside = false


func _on_sleep_body_entered(body: Node2D) -> void:
	if body.name == "player":
		bed = true


func _on_sleep_body_exited(body: Node2D) -> void:
	if body.name == "player":
		bed = false
		
 #DAYS
func day():
	Global.time_count = "day"
	
func evening():
	Global.time_count = "evening"
	
func night():
	Global.time_count = "night"
	
func morning():
	Global.time_count= "morning" 
