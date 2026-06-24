extends VBoxContainer
@onready var rollButton = $RollingButtons/RollButton
# Die
@onready var left_die = $DiceContainer/LeftDie
@onready var right_die = $DiceContainer/RightDie
# Atlas Textures: 0: D4, 1: D6, 2: D8
@export var die_textures: Array[AtlasTexture]

# Updates the button text after each inning
func _update_inning(isPlayer: bool) -> void:
	if isPlayer:
		rollButton.text = "BAT"
	else:
		rollButton.text = "PITCH"

# Emits the signal to roll the dice
func _roll_dice() -> void:
	Signalbus.roll_button_pressed.emit()

# Changes the texture of the dice
func _change_rolling_dice(left: int, right: int) -> void:
	left_die.texture = die_textures[left]
	right_die.texture = die_textures[right]
