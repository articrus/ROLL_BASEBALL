extends VBoxContainer
# Roll buttons
@onready var batBtn = $RollingButtons/BattingButton
@onready var pitchBtn = $RollingButtons/PitchingButton
# Die
@onready var left_die = $DiceContainer/LeftDie
@onready var right_die = $DiceContainer/RightDie
# Atlas Textures: 0: D4, 1: D6, 2: D8
@export var die_textures: Array[AtlasTexture]

# Toggles the visibility of the bat and pitch buttons
func _toggle_buttons(bat: bool, pitch: bool) -> void:
	batBtn.visible = bat
	pitchBtn.visible = pitch

# Emits the bat signal
func _bat_button() -> void:
	Signalbus.bat_pressed.emit()

# Emits the pitch signal
func _pitch_button() -> void:
	Signalbus.pitch_pressed.emit()

# Changes the texture of the dice
func _change_rolling_dice(left: int, right: int) -> void:
	left_die.texture = die_textures[left]
	right_die.texture = die_textures[right]
