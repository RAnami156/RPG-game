extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var text = $npcText
var speed = 50  # Adjust movement speed
var target_position = Vector2(450, 20)  # Where to move

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Global.quest_talk:
		
		var direction = (target_position - global_position).normalized()
		global_position += direction * speed * delta
		
		if global_position.distance_to(target_position) > 5:
			anim.play("Walk")
		else:
			Global.quest_talk = false
			anim.play("Idle") 
			await get_tree().create_timer(2.0).timeout
			queue_free()
	else:
		anim.play("Idle")
		
		


func _on_area_2d_body_entered(body: Node2D) -> void:
	text.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	text.visible = false
