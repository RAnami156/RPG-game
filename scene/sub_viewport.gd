extends SubViewport
 
@onready var camera = $Camera2D
@onready var sprite = $Sprite2D
 
func _physics_process(_delta):
	camera.position = Global.player_position
	sprite.position = Global.player_position
