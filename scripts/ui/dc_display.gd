extends Control
@onready var DCName = $TextureRect/VBoxContainer/DCName
@onready var DCValue = $TextureRect/VBoxContainer/DCValue

func _set_dc_name(isBatting: bool) -> void:
	if isBatting:
		DCName.text = "[color=blue]STEAL[/color]"
	else:
		DCName.text = "[color=blue]TAG OUT[/color]"

func _set_dc_value(value: int) -> void:
	DCValue.text = str(value)
