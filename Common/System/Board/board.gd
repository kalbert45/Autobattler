class_name Board extends Control

# Handles all board activity
# All board data manipulated through functions only 
signal check_battle_end

enum BOARD_SIDE {
	LEFT = 1 << 0,
	RIGHT = 1 << 1,
}

@export var _grid : Grid
@export var tiles_node : GridContainer
@export var units_node : Control

# CONTAINS PLAYER BOARD + ENEMY BOARD
@export var _tile_occupants : Dictionary[Vector2i, Unit] 

func _ready() -> void:
	for i in range(_grid.size.x):
		for j in range(_grid.size.y):
			get_tile(Vector2i(i, j)).grid_p = Vector2i(i, j)

# puts all the units on the board given the data
func initialize(player_board : Dictionary[Vector2i, UnitData], 
		enemy_board : Dictionary[Vector2i, UnitData] = {}) -> void:
	for coord in player_board.keys():
		var unit : Unit = load(player_board[coord].uid).instantiate()
		unit.data = player_board[coord]
		unit.SIDE = Unit.SIDE_FLAGS.PLAYER
		_tile_occupants[coord] = unit
		units_node.add_child(unit)
		unit.global_position = get_tile(coord).global_position
		unit._board = self
	for coord in enemy_board.keys():
		var unit : Unit = load(enemy_board[coord].uid).instantiate()
		unit.data = enemy_board[coord]
		unit.SIDE = Unit.SIDE_FLAGS.ENEMY
		_tile_occupants[_grid.flip_h(coord)] = unit
		units_node.add_child(unit)
		unit.global_position = get_tile(_grid.flip_h(coord)).global_position
		unit._board = self

func board_as_data() -> Dictionary[Vector2i, UnitData]:
	var result : Dictionary[Vector2i, UnitData] = {}
	for coord in _tile_occupants.keys():
		var unit = _tile_occupants.get(coord)
		if is_instance_valid(unit):
			result[coord] = unit.data
	return result

#----------------------------
func get_coords_in_range(unit : Unit, offset_coords : Array[Vector2i], flip_h : bool = false) -> Array[Vector2i]:
	var unit_coord = find_unit_coord(unit)
	if unit_coord.x < 0:
		return []
	
	var result : Array[Vector2i] = []
	for c in offset_coords:
		var query_coord = unit_coord + Vector2i(c.x * (-1 if flip_h else 1), c.y)
		if _grid.is_within_bounds(query_coord):
			result.append(query_coord)
	return result

func find_unit_coord(unit : Unit) -> Vector2i:
	for coord in _tile_occupants:
		if unit == _tile_occupants[coord]:
			return coord
	return -Vector2i.ONE

func is_coord_available(coord : Vector2i) -> bool:
	return not _tile_occupants.get(coord)

func get_tile(coord : Vector2i) -> Tile:
	var index = _grid.as_index(coord)
	if index < tiles_node.get_child_count():
		return tiles_node.get_child(_grid.as_index(coord))
	return null

func get_empty_tiles() -> Array[Tile]:
	var result : Array[Tile] = []
	for i in range(_grid.size.x):
		for j in range(_grid.size.y):
			if not is_instance_valid(_tile_occupants.get(Vector2i(i, j))):
				result.append(get_tile(Vector2i(i, j)))
	return result

#-------------------------
func add_unit(unit : Unit, coord : Vector2i) -> bool:
	if _tile_occupants.get(coord) : return false
	_tile_occupants[coord] = unit
	unit.reparent(units_node)
	return true

func remove_unit(unit : Unit) -> void:
	var coord = find_unit_coord(unit)
	_tile_occupants.erase(coord)
	emit_signal("check_battle_end")

func move_unit(unit : Unit, target_coord : Vector2i) -> void:
	remove_unit(unit)
	_tile_occupants[target_coord] = unit
	await unit.move_to(get_tile(target_coord).global_position)

#--------------------------
func damage_all_coords(dmg : DamageSource, coords : Array[Vector2i]) -> void:
	for c in coords:
		damage_coord(dmg, c)

# return true if success, false otherwise
func damage_coord(dmg : DamageSource, coord : Vector2i) -> bool:
	if not _grid.is_within_bounds(coord):
		return false
	var unit : Unit = _tile_occupants.get(coord)
	var tile = get_tile(coord)
	tile.damage_flash()
	if not unit:
		return false
	unit.take_damage(dmg)
	return true
