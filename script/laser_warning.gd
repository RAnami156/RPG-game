extends Node2D

@onready var line = $Line2D

var direction = Vector2.ZERO
var length = 600.0

func _ready() -> void:
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(direction * length)
	
	# Мигаем и исчезаем
	blink()

func blink() -> void:
	for i in 3:
		line.visible = true
		await get_tree().create_timer(0.2).timeout
		line.visible = false
		await get_tree().create_timer(0.2).timeout
	
	queue_free()
