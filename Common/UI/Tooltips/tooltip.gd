class_name Tooltip extends PanelContainer

func set_tooltip(obj) -> void:
	obj.accept_tooltip(self)
	
func set_unit_tooltip(unit : Unit) -> void:
	%Tier.text = str(unit.data.tier)
	%NameLabel.text = unit.data.name
	%Price.text = str(unit.data.price)
	%TTLabel.text = unit.data.tooltip
