extends Area2D

var direction = Vector2.ZERO
var speed = 200
var damage = 50

func _physics_process(delta) -> void:
	position += direction * speed * delta
	
	# Проверяем вручную все тела в зоне
	for body in get_overlapping_bodies():
		if body.name == "player":
			Global.player_healht -= damage
			print("Player HP: ", Global.player_healht)
			queue_free()
			return
	
	# Удаляем если улетела далеко за сцену
	if position.length() > 5000:
		queue_free()
