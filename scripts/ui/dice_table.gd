extends Control
@onready var rulesButtons = {
	Enums.RULES.BATTING: $VBoxContainer/Batting,
	Enums.RULES.PITCHING: $VBoxContainer/Pitching,
	Enums.RULES.SPECIAL: $VBoxContainer/Special,
	Enums.RULES.DICE: $VBoxContainer/Dice
}
@onready var textBoxes = {
	Enums.RULES.BATTING: $VBoxContainer/BattingBox,
	Enums.RULES.PITCHING: $VBoxContainer/PitchingBox,
	Enums.RULES.SPECIAL: $VBoxContainer/SpecialBox,
	Enums.RULES.DICE: $VBoxContainer/DiceBox
}

func _ready() -> void:
	_bind_buttons()

# Closes the dice table screen
func _on_close_pressed() -> void:
	self.visible = false

# Toggle the visibility of the rules box
func _on_ruleset_button_pressed(rule: Enums.RULES) -> void:
	for textBox in textBoxes:
		textBoxes[textBox].visible = textBox == rule

func _bind_buttons() -> void:
	for textButton in rulesButtons:
		rulesButtons[textButton].pressed.connect(_on_ruleset_button_pressed.bind(textButton))
