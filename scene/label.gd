extends Label

func _process(delta: float) -> void:
	visible = Global.end == true
