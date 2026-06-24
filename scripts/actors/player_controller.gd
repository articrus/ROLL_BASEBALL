extends Node2D
class_name PlayerController
@onready var sprite = $Sprite2D
# Movement Vars
@export var tween_time: float = 0.3

func _set_team_color(team: Enums.CITY) -> void:
	sprite.modulate = Enums.CITY_COLORS[team]

# Move batter to next position
func _set_player_position(newPos: Vector2) -> Tween:
	var tween = create_tween()
	tween.tween_property(self, "global_position", newPos, tween_time)
	return tween
