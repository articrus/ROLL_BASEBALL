extends VBoxContainer
@onready var rollButton = $RollButton
# Die
@onready var left_die = $DiceContainer/LeftDie
@onready var right_die = $DiceContainer/RightDie
# Atlas Textures: 0: D4, 1: D6, 2: D8
@export var die_textures: Array[AtlasTexture]
@export var d4Textures: Array[AtlasTexture]
@export var d6Textures: Array[AtlasTexture]
@export var d8Textures: Array[AtlasTexture]

func _ready() -> void:
	Signalbus.disable_roll.connect(_disable_roll_button)
	Signalbus.update_die_faces.connect(_display_die_results)

# Prevents the spamming of the roll button
func _disable_roll_button(toggle: bool) -> void:
	rollButton.disabled = toggle

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

func _display_die_results(leftDie: Enums.DIE_TYPES, leftResult: int, rightDie: Enums.DIE_TYPES, rightResult: int) -> void:
	match leftDie:
		Enums.DIE_TYPES.POWER:
			left_die.texture = d4Textures[leftResult]
		Enums.DIE_TYPES.NORMAL:
			left_die.texture = d6Textures[leftResult]
		Enums.DIE_TYPES.CONTACT:
			left_die.texture = d8Textures[leftResult]
	match rightDie:
		Enums.DIE_TYPES.POWER:
			right_die.texture = d4Textures[rightResult]
		Enums.DIE_TYPES.NORMAL:
			right_die.texture = d6Textures[rightResult]
		Enums.DIE_TYPES.CONTACT:
			right_die.texture = d8Textures[rightResult]
