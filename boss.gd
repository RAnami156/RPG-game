extends CharacterBody2D

@export var speed: float = 100.0

var player: Node2D = null
var is_chasing: bool = false


func _ready():
	pass
	#$AgroArea.body_entered.connect(_on_body_entered)
	#$AgroArea.body_exited.connect(_on_body_exited)


func _physics_process(_delta):
	if not is_chasing or player == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		is_chasing = false
