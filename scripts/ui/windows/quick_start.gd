extends TextureRect
@onready var rulesText = {
	"Rules1": $Panel/VBoxContainer/Rules1,
	"Rules2": $Panel/VBoxContainer/Rules2,
	"Rules3": $Panel/VBoxContainer/Rules3,
	"Rules4": $Panel/VBoxContainer/Rules4
}
@onready var rulesButtons = {
	"Rules1": $Panel/VBoxContainer/RulesBtn1,
	"Rules2": $Panel/VBoxContainer/RulesBtn2,
	"Rules3": $Panel/VBoxContainer/RulesBtn3,
	"Rules4": $Panel/VBoxContainer/RulesBtn4
}

func _ready() -> void:
	_bind_buttons()

func _on_rules_button_pressed(rule: String) -> void:
	SoundManager._play_button()
	for textBox in rulesText:
		rulesText[textBox].visible = textBox == rule

func _bind_buttons() -> void:
	for textButton in rulesButtons:
		rulesButtons[textButton].pressed.connect(_on_rules_button_pressed.bind(textButton))

func _on_close_pressed() -> void:
	SoundManager._play_button()
	self.visible = false
