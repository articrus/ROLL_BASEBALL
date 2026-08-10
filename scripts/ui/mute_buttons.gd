extends CanvasLayer
@onready var musicButton = $Control/HBoxContainer/Music
@onready var soundsButton = $Control/HBoxContainer/Sounds

func _on_ready() -> void:
	pass

func _on_music_pressed() -> void:
	SoundManager._mute_music(musicButton.button_pressed)

func _on_sounds_pressed() -> void:
	SoundManager._mute_sounds(soundsButton.button_pressed)
