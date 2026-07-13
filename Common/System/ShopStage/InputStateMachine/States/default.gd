extends SelectionState

func handle_tile_selection(tile : Tile) -> void:
	pass
	
func handle_unit_selection(unit : Unit) -> void:
	finished.emit(MODES.UNIT_SELECTED, {"UNIT" = unit})

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

func enter(previous_state_path: String, data := {}) -> void:
	for tile in get_tree().get_nodes_in_group("Tiles"):
		tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for unit in get_tree().get_nodes_in_group("Units"):
		unit.mouse_filter = Control.MOUSE_FILTER_STOP
		unit.mouse_box.visible = true

func exit() -> void:
	pass
