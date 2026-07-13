class_name BattleStage extends Stage

@onready var board = $Board

func _ready() -> void:
	SignalBus.battle_end.connect(_on_battle_end)
	board.check_battle_end.connect(_on_check_battle_end)

func enter() -> void:
	var dummy_enemy : Dictionary[Vector2i, UnitData]= {Vector2i(2, 1) : load("res://Entities/Units/UNIT_DATAS/UD_WOLF.tres")}
	await get_tree().process_frame
	await get_tree().process_frame
	board.initialize(GameState.player_board, dummy_enemy)
	
func exit() -> void:
	SignalBus.emit_signal("exit_stage", self)

func _on_check_battle_end() -> void:
	var player_unit_count := 0
	var enemy_unit_count := 0
	for unit : Unit in get_tree().get_nodes_in_group("Units"):
		if not is_instance_valid(unit): continue
		if unit.SIDE == Unit.SIDE_FLAGS.PLAYER:
			player_unit_count += 1
		else:
			enemy_unit_count += 1
			
	if enemy_unit_count <= 0:
		SignalBus.emit_signal("battle_end", true)
	elif player_unit_count <= 0:
		SignalBus.emit_signal("battle_end", false)

func _on_battle_end(win : bool) -> void:
	if win:
		$PanelContainer/VBoxContainer/Label.text = "win"
		GameState.WINS += 1
	else :
		$PanelContainer/VBoxContainer/Label.text = "lose"
		GameState.LIVES -= GameState.ROUND
	$PanelContainer.visible = true

func _on_tempbutton_pressed() -> void:
	$tempbutton.visible = false
	SignalBus.emit_signal("battle_start")


func _on_exit_button_pressed() -> void:
	exit()
