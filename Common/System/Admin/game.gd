class_name Game extends Control

enum STAGE {SHOP, BATTLE}

const STAGE_PATHS = {
	STAGE.SHOP : "uid://ch8ecdvyt2vcr",
	STAGE.BATTLE : "uid://bhosli4oylklw",
}

var current_stage : Stage

func _ready() -> void:
	SignalBus.exit_stage.connect(_on_exit_stage)
	
	current_stage = $ShopStage
	current_stage.enter()

func _on_exit_stage(stage : Stage) -> void:
	if current_stage == stage:
		current_stage.queue_free()
		
	var new_stage : Stage
	if stage is ShopStage:
		new_stage = load(STAGE_PATHS[STAGE.BATTLE]).instantiate()
	elif stage is BattleStage:
		GameState.ROUND += 1
		
		new_stage = load(STAGE_PATHS[STAGE.SHOP]).instantiate()
	else:
		push_error("Unsupported exit stage signal")
		
	add_child(new_stage)
	current_stage = new_stage
	new_stage.enter()
