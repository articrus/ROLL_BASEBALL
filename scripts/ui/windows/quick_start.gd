extends TextureRect

func _on_close_pressed() -> void:
	SoundManager._play_button()
	self.visible = false
