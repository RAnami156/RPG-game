extends Node
#PLAYER
var player_healht = 100
var player_damage = 20
var player_position = Vector2(583,293)
var stamina = 100
#SLIME
var slime_data = [] # Массив словарей с данными слаймов: [{position: Vector2, health: float}, ...]
var slime_count = 0
var damage = false
var damage_to_display = 0
var days_count = -1
var end = false
