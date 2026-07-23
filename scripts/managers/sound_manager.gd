extends Node
# Sound Effects
@onready var scoreFanfareFiles = {
	Enums.BATTING_RESULT.HOMERUN: load("res://sounds/home_run.wav"),
	Enums.BATTING_RESULT.TRIPLE: load("res://sounds/triple.wav"),
	Enums.BATTING_RESULT.DOUBLE: load("res://sounds/double.wav"),
	Enums.BATTING_RESULT.SINGLE: load("res://sounds/single.wav"),
	Enums.BATTING_RESULT.STRIKEOUT: load("res://sounds/whistle.wav"),
	Enums.BATTING_RESULT.NONE: null
}
@onready var buttonBoopFile = load("res://sounds/boop.wav")
@onready var pitchSoundFile = load("res://sounds/pitch_bat.wav")
@onready var inningChangeFile = load("res://sounds/change_sides.wav")
@onready var diceRollFile = load("res://sounds/dice_roll.wav")
# Music
@onready var musicFile = load("res://sounds/JDSherbert - Ambiences Music Pack - Junction Jazz.wav")
# SFX
var scoreFanfare: AudioStreamPlayer
var pitchSound: AudioStreamPlayer
var inningChange: AudioStreamPlayer
var dieRoll: AudioStreamPlayer
var buttonBoop: AudioStreamPlayer
# Background Music
var backgroundMusic: AudioStreamPlayer
# Pitch Variances
var pitchVariance:= 0.15
var singleVariance:= 0.07

func _ready() -> void:
	backgroundMusic = AudioStreamPlayer.new()
	buttonBoop = AudioStreamPlayer.new()
	scoreFanfare = AudioStreamPlayer.new()
	pitchSound = AudioStreamPlayer.new()
	inningChange = AudioStreamPlayer.new()
	dieRoll = AudioStreamPlayer.new()
	# Assigning Streams
	backgroundMusic.stream = musicFile
	buttonBoop.stream = buttonBoopFile
	pitchSound.stream = pitchSoundFile
	inningChange.stream = inningChangeFile
	dieRoll.stream = diceRollFile
	# Adding the children
	add_child(backgroundMusic)
	add_child(buttonBoop)
	add_child(scoreFanfare)
	add_child(pitchSound)
	add_child(inningChange)
	add_child(dieRoll)

func _play_button() -> void:
	buttonBoop.play()

func _play_die_roll() -> void:
	dieRoll.pitch_scale = 1.0 + randf_range(-singleVariance, singleVariance)
	dieRoll.play()

func _play_pitch_sound() -> void:
	pitchSound.pitch_scale = 1.0 + randf_range(-pitchVariance, pitchVariance)
	pitchSound.play()

func _play_inning_change() -> void:
	inningChange.play()

func _play_score_fanfare(score: Enums.BATTING_RESULT) -> void:
	scoreFanfare.stop()
	scoreFanfare.stream = scoreFanfareFiles[score]
	match score:
		Enums.BATTING_RESULT.SINGLE, Enums.BATTING_RESULT.DOUBLE, Enums.BATTING_RESULT.STRIKEOUT:
			scoreFanfare.pitch_scale = 1.0 + randf_range(-singleVariance, singleVariance)
		_:
			scoreFanfare.pitch_scale = 1.0
	scoreFanfare.play()
