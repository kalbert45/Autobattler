class_name Tile extends MarginContainer

var grid_p : Vector2i

func toggle_hover(on : bool) -> void:
	$Sprite2D.frame = 2 if on else 0

func damage_flash() -> void:
	$AnimationPlayer.play("damage_flash")


func _on_mouse_entered() -> void:
	SignalBus.tile_hovered.emit(self, true)


func _on_mouse_exited() -> void:
	SignalBus.tile_hovered.emit(self, false)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") or event.is_action_pressed("Controller_A"):
		SignalBus.tile_selected.emit(self)
