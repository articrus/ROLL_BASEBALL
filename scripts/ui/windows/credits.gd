extends TextureRect

func _on_close() -> void:
	SoundManager._play_button()
	self.visible = false

func _on_credits_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
