extends Control
@onready var loginMenu = $Login
@onready var playerInfo = $PlayerInfo
@onready var infoMenu = $Panel/VBoxContainer/Info
@onready var diceTable = $DiceTable
@onready var menuButtons = {
	"Play": $Panel/VBoxContainer/Play,
	"Login": $Panel/VBoxContainer/Login,
	"Info": $Panel/VBoxContainer/Info,
	"Rules": $Panel/VBoxContainer/Rules
}
@onready var displayText = $DisplayText

func _ready() -> void:
	loginMenu.visible = false
	Signalbus.user_login.connect(_on_successful_login)
	loginMenu.confirm_sent.connect(_display_message)
	if AuthenticationManager.current_user_id == "":
		menuButtons.Info.disabled = true

# Display a warning message
func _display_message(message: String) -> void:
	displayText.visible = true
	displayText._set_text(message)

func _on_play_pressed() -> void:
	if AuthenticationManager.current_user_id == "":
		_display_message("YOU NEED TO LOGIN FIRST")
		#print("YOU NEED TO LOGIN FIRST")
		loginMenu.visible = true
	else:
		_start_game()

func _on_login_pressed() -> void:
	loginMenu.visible = true

func _on_successful_login() -> void:
	menuButtons.Info.disabled = false
	loginMenu.visible = false

func _on_info_pressed() -> void:
	playerInfo.visible = true
	playerInfo._on_visible()

func _start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")

func _on_rules_pressed() -> void:
	diceTable.visible = true
