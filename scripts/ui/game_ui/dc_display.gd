extends Control
@onready var DCName = $TextureRect/VBoxContainer/DCName
@onready var DCValue = $TextureRect/VBoxContainer/DCValue

func _set_dc_name(isBatting: bool) -> void:
	if isBatting:
		DCName.text = "[color=cyan]STEAL[/color]"
	else:
		DCName.text = "[color=cyan]TAG OUT[/color]"

func _set_dc_value(value: int) -> void:
	DCValue.text = str(value)
