class_name InputStateMachine extends Node

@export var initial_state: SelectionState = null

@onready var state: SelectionState = (func get_initial_state() -> SelectionState:
	return initial_state if initial_state != null else get_child(0)
).call()


func _ready() -> void:
	for state_node: SelectionState in find_children("*", "SelectionState"):
		state_node.finished.connect(_transition_to_next_state)

	await owner.ready
	state.enter("")

func handle_tile_selection(tile : Tile) -> void:
	state.handle_tile_selection(tile)
	
func handle_unit_selection(unit : Unit) -> void:
	state.handle_unit_selection(unit)

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)
	

func _transition_to_next_state(target_state_path: String, data: Dictionary = {
}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
