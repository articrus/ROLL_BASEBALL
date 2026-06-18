extends Control
@onready var loginMenu = $Login

func _ready() -> void:
	loginMenu.visible = false
	Signalbus.user_login.connect(_on_successful_login)

func _on_play_pressed() -> void:
	if AuthenticationManager.current_user_id == "":
		print("YOU NEED TO LOGIN FIRST")
		loginMenu.visible = true
	else:
		_on_successful_login()

func _on_login_pressed() -> void:
	loginMenu.visible = true

func _on_successful_login() -> void:
	loginMenu.visible = false
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
