extends Node
#PLAYER
var player_healht = 100
var player_damage = 20
var player_position = Vector2(583,293)
var stamina = 100

#ANIMATION
var animation_position = 0.0  # Добавлена переменная для хранения позиции анимации

#SLIME
var slime_data = [] # Массив словарей с данными слаймов: [{position: Vector2, health: float}, ...]
var slime_count = 0

var slime_killed  = 0
var current_scene = "res://scene/world.tscn"
var time_count = "day"
var damage = false
var damage_to_display = 0
var days_count = 0
var end = false
