extends Node2D
class_name PlayerController
@onready var bodySprite = $Body
@onready var capSprite = $Hats/Cap
# Cap Segments
@onready var capBot = $Hats/Cap/CapBottom
@onready var capTop = $Hats/Cap/CapTop
# Helmet
@onready var helmetSprite = $Hats/Helmet
# Movement Vars
@export var tween_time: float = 0.3

func _setup_player(team: Enums.CITY, isBatting: bool) -> void:
	_set_team_color(team)
	_set_team_position(isBatting, team)

func _set_team_color(team: Enums.CITY) -> void:
	bodySprite.modulate = Enums.CITY_COLORS[team]

# Changes the hats
func _set_team_position(batting: bool, team: Enums.CITY) -> void:
	if batting:
		helmetSprite.visible = true
		helmetSprite.modulate = Enums.CITY_SECOND_COLORS[team]
		capSprite.visible = false
	else:
		helmetSprite.visible = false
		capSprite.visible = true
		capTop.modulate = Enums.CITY_COLORS[team]
		capBot.modulate = Enums.CITY_SECOND_COLORS[team]

# Move batter to next position
func _set_player_position(newPos: Vector2) -> Tween:
	var tween = create_tween()
	_flip_chara(newPos.x < global_position.x)
	tween.tween_property(self, "global_position", newPos, tween_time)
	return tween

# For when striking out
func _strikeout(newPos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", newPos, tween_time)
	await tween.finished
	self.queue_free()

# For when crossing the home plate
func _return_home(newPos: Vector2) -> Tween:
	var tween = create_tween()
	tween.tween_property(self, "global_position", newPos, tween_time)
	return tween

# Flips the x scale
func _flip_chara(flip: bool) -> void:
	if flip:
		self.scale.x *= -1
	else:
		self.scale.x = (abs(self.scale.x))
