extends SelectionState

var selected_unit : Unit

# move unit
func handle_tile_selection(tile : Tile) -> void:
	if selected_unit.in_shop:
		if selected_unit.data.price < GameState.MONEY:
			GameState.MONEY -= selected_unit.data.price
			selected_unit.in_shop = false
			board.add_unit(selected_unit, tile.grid_p)
			board.move_unit(selected_unit, tile.grid_p)
			finished.emit(MODES.DEFAULT)
	else:
		board.move_unit(selected_unit, tile.grid_p)
		finished.emit(MODES.DEFAULT)

# combine units
func handle_unit_selection(unit : Unit) -> void:
	pass

## Called by the state machine when receiving unhandled input events.
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		finished.emit(MODES.DEFAULT)

func enter(previous_state_path: String, data := {}) -> void:
	selected_unit = data["UNIT"]
	selected_unit.selected = true
	for tile in board.get_empty_tiles():
		tile.mouse_filter = Control.MOUSE_FILTER_STOP
	for unit in get_tree().get_nodes_in_group("Units"):
		if unit.name == selected_unit.name and unit != selected_unit:
			unit.mouse_filter = Control.MOUSE_FILTER_STOP
			unit.mouse_box.visible = true
		else:
			unit.mouse_filter = Control.MOUSE_FILTER_IGNORE
			unit.mouse_box.visible = false

func exit() -> void:
	selected_unit.selected = false
	for tile in get_tree().get_nodes_in_group("Tiles"):
		tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for unit in get_tree().get_nodes_in_group("Units"):
		unit.mouse_filter = Control.MOUSE_FILTER_STOP
		unit.mouse_box.visible = true
