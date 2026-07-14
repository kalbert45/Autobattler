extends RichTextLabel

func _ready() -> void:
	GameState.money_changed.connect(_on_money_changed)
	text = str(GameState.MONEY)

func _on_money_changed(value : int):
	text = str(value)
