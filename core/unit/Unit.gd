extends KinematicBody2D
class_name Unit

signal movement_done
signal left_clicked

const SPEED := 40.0

export var move_points := 4

var path := PoolVector2Array([])

onready var animated_sprite := $AnimatedSprite

func _ready():
	animated_sprite.play("idle")
	

func _physics_process(delta: float):
	if not path.empty():
		animated_sprite.play("run")
		_move_along_path(delta)
		if path.empty():
			animated_sprite.flip_h = false
			emit_signal("movement_done")
	else:
		animated_sprite.play("idle")


func set_path(_path: PoolVector2Array):
	path = _path


func _move_along_path(delta: float):
	var distance = SPEED * delta
	_rotate_to_point(path[path.size() - 1])
	for i in range(path.size()):
		var next_point = path[0]
		var dist_to_next_point = position.distance_to(next_point)
		if distance <= dist_to_next_point and distance >= 0.0:
			move_and_slide(position.direction_to(next_point).normalized() * SPEED)
			break
		distance -= dist_to_next_point
		move_and_slide(position.direction_to(next_point).normalized() * SPEED)
		path.remove(0)


func _rotate_to_point(point: Vector2):
	animated_sprite.flip_h = position.x - point.x > 2


func _handle_input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("left_clicked")
