extends Button
@export var city: Enums.CITY

func _on_mouse_entered() -> void:
	Signalbus.team_highlight.emit(city)

func _on_focus_entered() -> void:
	Signalbus.team_highlight.emit(city)
