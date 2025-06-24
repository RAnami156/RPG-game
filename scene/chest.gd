extends Node2D

@onready var anim = $AnimationPlayer

var body_in = false

func _ready() -> void:
	$Label.visible = false
	anim.play("idle")
	
func _physics_process(delta: float) -> void:
	if body_in == true and Input.is_action_just_pressed("E"):
		anim.play("open")
		Global.player_money += 3
		await anim.animation_finished
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body_in = true
	$Label.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	body_in = false
	$Label.visible = false
