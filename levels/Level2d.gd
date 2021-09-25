extends YSort

#const path_tile_texture: Texture = preload("res://assets/path-tile-16x16.png")
const path_area_tile_scene = preload("res://core/path_area_tile/PathAreaTile.tscn")

var path_finder: PathFinder
var units: Array
var selected_unit: Unit
var move_area_container: Node2D

func _ready():
	path_finder = PathFinder.new($Ground)
	units = $Units.get_children()
	fix_units_positions(units)
	subscribe_to_units_signals(units)


func _input(event: InputEvent):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_LEFT or not event.pressed:
		return
	if selected_unit:
		_clear_move_area()
		var mouse_position = get_global_mouse_position()
		if not _is_unit_point(mouse_position):
			_move_unit_to_point(selected_unit, mouse_position)


# Изменяет расположение юитов, чтобы те находились в центре ячеек сетки
func fix_units_positions(units: Array):
	for unit in units:
		unit.position = path_finder.get_closest_grid_position(unit.position)


# Подписка на сигналы юнитов
func subscribe_to_units_signals(units: Array):
	for unit in units:
		unit.connect("left_clicked", self, "_handle_unit_selection", [unit])
		unit.connect("movement_done", self, "_handle_unit_movement_end", [unit])


func _handle_unit_selection(unit: Unit):
	selected_unit = unit
	_clear_move_area()
	_draw_move_area(selected_unit)


func _handle_unit_movement_end(unit: Unit):
	pass


# Рисует зону передвижения юнита
func _draw_move_area(unit: Unit):
	move_area_container = Node2D.new()
	var move_area = path_finder.get_points_in_radius(unit.position, unit.move_points)
	for point in move_area:
		var path_area_tile = path_area_tile_scene.instance()
#		point_sprite.texture = path_tile_texture
		path_area_tile.position = point
		move_area_container.add_child(path_area_tile)
	add_child(move_area_container)


func _clear_move_area():
	if move_area_container != null:
		remove_child(move_area_container)
		move_area_container.queue_free()
		move_area_container = null


func _is_unit_point(point: Vector2):
	for unit in units:
		if path_finder.are_equal_cell_points(point, unit.position):
			return true
	return false


func _move_unit_to_point(unit: Unit, point: Vector2):
	var path = path_finder.get_move_path(unit.position, point)
	unit.set_path(path)
	unit = null
