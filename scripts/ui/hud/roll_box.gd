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

func _animate_die(die: TextureRect, dieType: Enums.DIE_TYPES) -> Tween:
	die.pivot_offset = die.size/2
	var duration = 0.7
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(die, "rotation_degrees", 360 * 3, duration) \
		.as_relative() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)
	# Flickering
	var flicker_interval = 0.1
	var elapsed = 0
	while elapsed < duration:
		tween.tween_callback(_set_random_face.bind(die, dieType)).set_delay(elapsed)
		elapsed += flicker_interval
	tween.chain().tween_callback(func():
		die.rotation_degrees = 0.0)
	return tween

func _set_random_face(die: TextureRect, dieType: Enums.DIE_TYPES) -> void:
	var roll = 0
	match dieType:
		Enums.DIE_TYPES.POWER:
			roll = randi_range(1, 4)
			die.texture = d4Textures[roll]
		Enums.DIE_TYPES.NORMAL:
			roll = randi_range(1, 6)
			die.texture = d6Textures[roll]
		Enums.DIE_TYPES.CONTACT:
			roll = randi_range(1, 8)
			die.texture = d8Textures[roll]

# Animate the dice rolling, taking the die and result to assign the apropriate face
func _display_die_results(leftDie: Enums.DIE_TYPES, leftResult: int, rightDie: Enums.DIE_TYPES, rightResult: int) -> void:
	_animate_die(left_die, leftDie)
	await _animate_die(right_die, rightDie).finished
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
	Signalbus.resume_processing.emit()
