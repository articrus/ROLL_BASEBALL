extends Node2D
class_name PlayerController
@onready var bodySprite = $Body
@onready var hatSprite = $Hats/Hat
@onready var helmetSprite = $Hats/Helmet
# Movement Vars
@export var tween_time: float = 0.3

func _set_team_color(team: Enums.CITY) -> void:
	bodySprite.modulate = Enums.CITY_COLORS[team]

# Changes the hats
func _set_team_position(batting: bool) -> void:
	if batting:
		helmetSprite.visible = true
		hatSprite.visible = false
	else:
		helmetSprite.visible = false
		hatSprite.visible = true

# Move batter to next position
func _set_player_position(newPos: Vector2) -> Tween:
	var tween = create_tween()
	tween.tween_property(self, "global_position", newPos, tween_time)
	return tween

# For when striking out
func _strikeout(newPos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", newPos, tween_time)
	await tween.finished
	self.queue_free()
