class_name Unit extends Control

enum SIDE_FLAGS {PLAYER, ENEMY}
var SIDE := SIDE_FLAGS.PLAYER

var data : UnitData

var initiative := 0 # tiebreaker for ability uses
var current_grid_p : Vector2

# define locally(?)
func use_ability() -> void:
	pass
