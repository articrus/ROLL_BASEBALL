extends TextureRect
@onready var infoText = {
	"GameOver": $Panel/HBoxContainer/GameOver,
	"PlayerPoints": $Panel/HBoxContainer/HomePoints,
	"ComPoints": $Panel/HBoxContainer/VisitorPoints,
	"Average": $Panel/HBoxContainer/AveragePoints
}
@onready var trophy = $Trophy
# Buttons
@onready var playAgainBtn = $Panel/HBoxContainer/PlayAgain
@onready var quitBtn = $Panel/HBoxContainer/Quit
# Login screen just in case
@onready var loginUI = $Login
# Export Vars
@export var max_time: float = 5.0
@export var typing_speed : float = 60
# Other Vars
var typing_time : float
var time_elapsed: float

func _display_info(home: int, visit: int, av: float, victory: bool) -> void:
	if victory:
		trophy.visible = true
	await get_tree().create_timer(1).timeout
	if victory:
		await _type_text("WINNER!", infoText["GameOver"])
	else:
		await _type_text("GAME OVER", infoText["GameOver"])
	await _type_text("Home Points: " + str(home), infoText["PlayerPoints"])
	await _type_text("Visitor Points: " + str(visit), infoText["ComPoints"])
	await _type_text("Average Points per Inning: " + str(av), infoText["Average"])
	await get_tree().create_timer(3).timeout
	playAgainBtn.visible = true
	quitBtn.visible = true

# Types the displayed text
func _type_text(data: String, label: Label) -> void:
	time_elapsed = 0
	label.text = data
	label.visible_characters = 0
	typing_time = 0
	while label.visible_characters < label.get_total_character_count():
		typing_time += get_process_delta_time()
		label.visible_characters = typing_speed * typing_time as int
		await get_tree().process_frame

func _on_play_again() -> void:
	if AuthenticationManager.current_user_id == "":
		loginUI.visible = true
	else:
		get_tree().change_scene_to_file("res://scenes/game_scene.tscn")

func _on_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
