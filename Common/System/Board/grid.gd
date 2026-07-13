# Represents a grid. Includes helper functions for navigating the grid
class_name Grid
extends Resource


# grid's size
@export var size = Vector2i(20,20)
# size of a cell in pixels
@export var cell_size = Vector2i(80,80)
@export var dividing_col := 3 # all cols below this value is friendly

# half of cell size
# used to calculate center of cell
var _half_cell_size = cell_size / 2

#func _init(grid_size, _cell_size):
	#size = grid_size
	#cell_size = _cell_size

func calculate_map_position(grid_position: Vector2i) -> Vector2:
	return grid_position * cell_size + _half_cell_size


func calculate_grid_coordinates(map_position: Vector2) -> Vector2i:
	return Vector2i(round(map_position / Vector2(cell_size)))


func is_within_bounds(cell_coordinates: Vector2i) -> bool:
	var out = cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y


func clamp(grid_position: Vector2i) -> Vector2i:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1)
	out.y = clamp(out.y, 0, size.y - 1)
	return out


func flip_h(coord : Vector2i) -> Vector2i:
	return Vector2i(size.x - coord.x - 1, coord.y)

func as_index(cell: Vector2i) -> int:
	return int(cell.x + size.x * cell.y)
	
func as_coord(index: int) -> Vector2i:
	return Vector2i(index % size.x, index / size.x)
	
# Return random point on grid. Used for various generation algorithms
func random_point() -> Vector2i:
	return Vector2i(randi_range(0, size.x-1), randi_range(0, size.y-1))
