extends Node2D

func _physics_process(delta: float) -> void:
	
	if Global.quest_sleep == true and Global.quest_kill == true:
		$AnimationPlayer.play("exit")
		await  $AnimationPlayer.animation_finished
		queue_free()
	
	if Global.quest_sleep == false:
		$sleep/Yes.visible = true
		$sleep/No.visible = false
	else:
		$sleep/Yes.visible = false
		$sleep/No.visible = true
		
	if Global.quest_kill == false :
		$kill/Yes.visible = true
		$kill/No.visible = false
	else:
		$kill/Yes.visible = false
		$kill/No.visible = true
