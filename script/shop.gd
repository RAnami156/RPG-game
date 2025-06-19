extends Node2D

@onready var anim = $AnimatedSprite2D

var player_in = false

func _ready() -> void:
	anim.play("idle")
	$Node2D.visible = false

#func _physics_process(delta: float) -> void:
	#print(player_in)


func _on_area_2d_body_entered(body: Node2D) -> void:
	$Node2D.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	$Node2D.visible = false


func _on_heath_2_pressed() -> void:
	if Global.player_money >= 2:
		Global.player_money -= 2
		Global.max_health += 20
