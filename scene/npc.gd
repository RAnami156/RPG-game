extends Node2D

@onready var anim = $AnimatedSprite2D
@onready var text = $npcText
var body_in = true
var speed = 50  
var target_position = Vector2(450, 20)  
var talk = false
var kola = ["Hello", "Nigger", "Raw lox"]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	#print(body_in)
	#if Input.is_action_just_pressed("E"):
		#print("piska", talk)
		
	if body_in and Input.is_action_just_pressed("E"):
		talk = true
	
	if talk and Input.is_action_just_pressed("E"):
		for i in range(kola.size()):
			print(i)
			if Input.is_action_just_pressed("E"):
				text.text = kola[i]
	
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
