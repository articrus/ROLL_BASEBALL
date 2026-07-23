extends Control
@onready var rulesButtons = {
	Enums.RULES.GENERAL: $Panel/VBoxContainer/General,
	Enums.RULES.BATTING: $Panel/VBoxContainer/Batting,
	Enums.RULES.PITCHING: $Panel/VBoxContainer/Pitching,
	Enums.RULES.SPECIAL: $Panel/VBoxContainer/Special,
	Enums.RULES.DICE: $Panel/VBoxContainer/Dice
}
@onready var textBoxes = {
	Enums.RULES.GENERAL: $Panel/VBoxContainer/GeneralBox,
	Enums.RULES.BATTING: $Panel/VBoxContainer/BattingBox,
	Enums.RULES.PITCHING: $Panel/VBoxContainer/PitchingBox,
	Enums.RULES.SPECIAL: $Panel/VBoxContainer/SpecialBox,
	Enums.RULES.DICE: $Panel/VBoxContainer/DiceBox
}

func _ready() -> void:
	_bind_buttons()

# Closes the dice table screen
func _on_close_pressed() -> void:
	SoundManager._play_button()
	self.visible = false

# Toggle the visibility of the rules box
func _on_ruleset_button_pressed(rule: Enums.RULES) -> void:
	SoundManager._play_button()
	for textBox in textBoxes:
		textBoxes[textBox].visible = textBox == rule

func _bind_buttons() -> void:
	for textButton in rulesButtons:
		rulesButtons[textButton].pressed.connect(_on_ruleset_button_pressed.bind(textButton))
