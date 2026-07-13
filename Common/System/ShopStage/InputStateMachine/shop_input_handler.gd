extends Node

@onready var input_state_machine : InputStateMachine = $InputStateMachine

func _ready() -> void:
	SignalBus.tile_hovered.connect(_on_tile_hovered)
	SignalBus.tile_selected.connect(_on_tile_selected)
	SignalBus.unit_hovered.connect(_on_unit_hovered)
	SignalBus.unit_selected.connect(_on_unit_selected)

func _on_unit_hovered(unit : Unit, on :bool):
	unit.toggle_tooltip(on)
	
func _on_unit_selected(unit : Unit):
	input_state_machine.handle_unit_selection(unit)
	
func _on_tile_hovered(tile : Tile, on : bool):
	tile.toggle_hover(on)
	
func _on_tile_selected(tile : Tile):
	input_state_machine.handle_tile_selection(tile)
