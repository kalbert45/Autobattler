extends Node

signal money_changed(value : int)

var MONEY := 0 :
	set(value):
		MONEY = value
		emit_signal("money_changed", MONEY)
var LIVES := 3
var ROUND := 1
var WINS := 0
var player_board : Dictionary[Vector2i, UnitData] = {}


func get_player_board_json() -> String:
	var data = {}
	for coord in player_board.keys():
		data[coord] = player_board[coord].create_json()
		
	var result = JSON.stringify(data)
	return result
	
func load_board_json(json : String) -> Dictionary[Vector2i, UnitData]:
	var result : Dictionary[Vector2i, UnitData] = {}
	if json.is_empty(): return result
	var data = JSON.parse_string(json)
	
	for key in data.keys():
		result[str_to_var("Vector2i" + key)] = UnitData.new(data[key])
		
	return result
	
