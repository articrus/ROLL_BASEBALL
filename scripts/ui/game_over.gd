extends Control
@onready var infoText = {
	"GameOver": $Panel/HBoxContainer/GameOver,
	"PlayerPoints": $Panel/HBoxContainer/HomePoints,
	"ComPoints": $Panel/HBoxContainer/VisitorPoints,
	"Average": $Panel/HBoxContainer/AveragePoints
}

func _display_info(home: int, visit: int, av: float, victory: bool) -> void:
	if victory:
		infoText["GameOver"].text = "WINNER!"
	else:
		infoText["GameOver"].text = "GAME OVER"
	infoText["PlayerPoints"].text = "Home Points: " + str(home)
	infoText["ComPoints"].text = "Visitor Points: " + str(visit)
	infoText["Average"].text = "Average Points per Inning: " + str(av)

func _on_play_again() -> void:
	if AuthenticationManager.current_user_id == "":
		pass # Prompt login again
	else:
		get_tree().change_scene_to_file("res://scenes/game_scene.tscn")

func _on_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
