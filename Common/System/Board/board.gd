class_name Board extends Control

# Handles all board activity
# All board data manipulated through functions only 

@export var _grid : Grid

var _tile_occupants : Dictionary[Vector2i, Unit]

#----------------------------
func find_unit_coord(unit : Unit) -> Vector2i:
	for coord in _tile_occupants:
		if unit == _tile_occupants[coord]:
			return coord
	return -Vector2i.ONE

#-------------------------
func add_unit(unit : Unit, coord : Vector2i) -> bool:
	if _tile_occupants[coord] : return false
	_tile_occupants[coord] = unit
	return true

func remove_unit(unit : Unit) -> void:
	var coord = find_unit_coord(unit)
	_tile_occupants.erase(coord)

func move_unit(unit : Unit, target_tile : Vector2i) -> void:
	pass

#--------------------------

func damage_tiles(dmg : DamageSource, tiles : Array[Vector2i]) -> void:
	pass
