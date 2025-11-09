extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var text = $npcText
var body_in = true
var speed = 50  
var target_position = Vector2(450, 20)  
var talk = false
var kola = ["Hello", "Nigger", "Ravil pidoras"]
var current_index = 0

func _process(delta: float) -> void:
	if body_in and Input.is_action_just_pressed("E"):
		if not talk:
			talk = true
			text.text = kola[current_index]
		else:
			current_index += 1
			if current_index < kola.size():
				text.text = kola[current_index]
			else:
				# Диалог закончился
				talk = false
				Global.quest_talk = true 
				current_index = 0
				text.text = ""
	
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
	body_in = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	text.visible = false
	body_in = false
