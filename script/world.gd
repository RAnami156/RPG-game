extends Node2D

@onready var animP = $AnimationPlayer
@onready var days = $CanvasLayer/days
@onready var time = $CanvasLayer/time
@onready var player = $player
@onready var enemys = $enemys

var house = false
var slime_preload = preload("res://scene/enemy.tscn")
var last_position = 0 

var puddle_scene = preload("res://puddle.tscn")
@export var puddle_lifetime: float = 10   # исчезают быстрее
@export var spawn_delay: float = 0.03      # почти спам
@export var puddle_max_count: int = 1000   # очень много

var puddle_count = 0
var puddle_timer: float = 0.0

func _ready():
	print("day:", Global.days_count)
	load_slimes()

	animP.play("day-night")
	animP.seek(Global.animation_position)
	last_position = Global.animation_position 

func _process(delta: float) -> void:
	spawn_puddle()
	if Global.player_healht <= 0:
		animP.stop()
	else:
		animP.play("day-night")

	if animP.current_animation_position < last_position:
		Global.days_count += 1
	
	last_position = animP.current_animation_position
	Global.animation_position = animP.current_animation_position

	days.text = str(Global.days_count) + " DAY"
	time.text = "time: "  + str(int(Global.animation_position)) + "h" + " (" + str(Global.time_count) + ")"

	$outside.visible = house

	if house and Input.is_action_just_pressed("E"):
		get_tree().change_scene_to_file("res://scene/house.tscn")
		Global.current_scene = "res://scene/house.tscn"
		Global.player_position = Vector2(128,88)

func day():
	Global.time_count = "day"

func evening():
	Global.time_count = "evening"

func night():
	Global.time_count = "night"

func morning():
	Global.time_count = "morning" 

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

		Global.slime_data.append({
			"position": slime.position,
			"health": 100
		})

		print("Slime spawned at:", slime.position)

func load_slimes():
	for slime_info in Global.slime_data:
		var slime = slime_preload.instantiate()
		slime.position = slime_info.position
		slime.health = slime_info.health
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



func spawn_puddle():
	var puddle = puddle_scene.instantiate()
	puddle.position = Vector2(
		randf_range(-1000, 2000),  # жесткий разлет по X
		randf_range(-1000, 2000)   # жесткий разлет по Y
	)
	add_child(puddle)
	puddle_count += 1

	var timer = get_tree().create_timer(puddle_lifetime)
	timer.timeout.connect(func():
		if is_instance_valid(puddle):
			puddle.queue_free()
		puddle_count -= 1
	)
