class_name ShopStage extends Stage

@onready var board = $Board

func enter() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	board.initialize(GameState.player_board)
	GameState.MONEY += 10
	reroll_shop()
	
func exit() -> void:
	$RerollButton.disabled = true
	$BattleButton.disabled = true
	
	GameState.player_board = board.board_as_data()
	await HTTPHandler.post_ghost()
	SignalBus.emit_signal("exit_stage", self)

func reroll_shop() -> void:
	for shop_slot in $Shop/ShopSlotContainer.get_children():
		for child in shop_slot.get_children():
			if child is Unit:
				child.queue_free()
	
	var unit_data_pool = Generator.get_unit_data_pool(3, [0, 0], 0)
	for i in range(unit_data_pool.size()):
		var unit = load(unit_data_pool[i].uid).instantiate()
		unit.in_shop = true
		$Shop/ShopSlotContainer.get_child(i).add_child(unit)

func _on_reroll_button_pressed() -> void:
	reroll_shop()

func _on_battle_button_pressed() -> void:
	
	exit()

#-------------------------------------
