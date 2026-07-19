extends Node2D
class_name PlayerController
@onready var bodySprite = $Body
@onready var capSprite = $Hats/Cap
@onready var animPlayer = $AnimationPlayer
# Hats
@onready var capBot = $Hats/Cap/CapBottom
@onready var capTop = $Hats/Cap/CapTop
@onready var helmetSprite = $Hats/Helmet
# Objects
@onready var batSprite = $Objects/Bat
@onready var gloveSprite = $Objects/Glove
# Movement Vars
@export var tween_time: float = 0.3

func _setup_player(team: Enums.CITY, isBatting: bool) -> void:
	_set_team_color(team)
	_set_team_position(isBatting, team)

func _set_team_color(team: Enums.CITY) -> void:
	bodySprite.modulate = Enums.CITY_COLORS[team]

# Changes the hats
func _set_team_position(batting: bool, team: Enums.CITY) -> void:
	_set_player_idle(batting)
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

# Sets the idle animations for players
func _set_player_idle(isBatting: bool) -> void:
	if isBatting:
		batSprite.visible = true
		animPlayer.play("bat_idle")
	else:
		gloveSprite.visible = true
		animPlayer.play("glove_idle")

func _disable_objects() -> void:
	batSprite.visible = false
	gloveSprite.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "glove_pitch" || anim_name == "glove_catch":
		animPlayer.play("glove_idle")
	elif anim_name == "bat_swing":
		animPlayer.play("bat_idle")
	else:
		pass
