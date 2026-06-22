extends Control
@onready var loginMenu = $Login
@onready var playerInfo = $PlayerInfo
@onready var infoMenu = $VBoxContainer/Info
@onready var menuButtons = {
	"Play": $VBoxContainer/Play,
	"Login": $VBoxContainer/Login,
	"Info": $VBoxContainer/Info
}

func _ready() -> void:
	loginMenu.visible = false
	Signalbus.user_login.connect(_on_successful_login)
	if AuthenticationManager.current_user_id == "":
		menuButtons.Info.disabled = true

func _on_play_pressed() -> void:
	if AuthenticationManager.current_user_id == "":
		print("YOU NEED TO LOGIN FIRST")
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

func _start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
