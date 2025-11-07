extends Node
#PLAYER
var player_healht = 100 #save
var max_health = 100
var player_damage = 20 
var player_position = Vector2(565,325) #save
var stamina = 100 #save
var player_money = 0

var player_level = 0
var player_xp = 0
var xp_to_next_level = 100

#ANIMATION
var animation_position = 0.0  # Добавлена переменная для хранения позиции анимации

#BUTTON
var resume = false
var save = false
var load = false

#SLIME
var slime_data = [] # Массив словарей с данными слаймов: [{position: Vector2, health: float}, ...]  #save
var slime_count = 0  #save

var slime_killed  = 0 #save
var current_scene = "res://scene/world.tscn" #save
var time_count = "day" #save
var damage = false
var damage_to_display = 0
var days_count = 0 #save
var end = false #save

var quest_sleep = false
var quest_kill = false
var quest_talk = false 
