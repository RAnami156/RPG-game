extends Camera2D  # Наследуемся от Camera2D, чтобы управлять камерой

var zoom_speed = 0.1  # Скорость изменения масштаба
var min_zoom = 1.3  # Минимальный уровень зума
var max_zoom = 3.3  # Максимальный уровень зума
var can_zoom = true  # Флаг, разрешающий изменение зума
var original_pos  # Переменная для хранения изначального положения камеры

func _ready():
	original_pos = position  # Сохраняем стартовую позицию камеры

func _process(delta):
	if Global.damage:  # Если глобальная переменная damage == true (игрок получил урон)
		shake_camera()  # Запускаем тряску камеры

func _input(event):
	# Если зум включён и событие ввода - это прокрутка колеса мыши
	if can_zoom and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:  # Колесо вниз - отдаляем камеру
			zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:  # Колесо вверх - приближаем камеру
			zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func shake_camera():
	if not can_zoom:  # Если зум отключён, не трясём камеру
		return

	can_zoom = false  # Временно отключаем возможность изменения масштаба

	var tween = create_tween()  # Создаём анимацию (tween)
	var shake_strength = 80.0  # Сила тряски
	var shake_duration = 0.01  # Длительность одной фазы тряски (очень короткая)

	# Двигаем камеру резко в одну сторону
	tween.tween_property(self, "position", original_pos + Vector2(shake_strength, shake_strength), shake_duration)
	# Двигаем камеру резко в другую сторону
	tween.tween_property(self, "position", original_pos - Vector2(shake_strength, shake_strength), shake_duration)
	# Возвращаем камеру в исходное положение
	tween.tween_property(self, "position", original_pos, shake_duration)

	# Через 0.05 сек снова разрешаем изменение зума
	await get_tree().create_timer(0.05).timeout
	can_zoom = true
