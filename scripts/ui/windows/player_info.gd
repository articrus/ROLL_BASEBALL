extends Control
@onready var infoText = {
	"Wins": $HBoxContainer/WinsText,
	"Total": $HBoxContainer/ToalPoints,
	"Average": $HBoxContainer/AveragePoints
}
@onready var confirmBox = $Confirm

func _ready() -> void:
	_display_info()
	_toggle_confirm_box(false)

func _on_visible() -> void:
	_display_info()

func _display_info() -> void:
	var profile = await AuthenticationManager._load_profile()
	infoText.Wins.text = "Games Won: " + str(profile.get("games_won", 0))
	infoText.Total.text = "Total Points: " + str(profile.get("points_scored", 0))
	infoText.Average.text = "Average Points per Inning: " + str(profile.get("average_points_per", 0))

func _reset_info() -> void:
	AuthenticationManager._reset_stats()
	_display_info()

func _toggle_confirm_box(toggle: bool) -> void:
	confirmBox.visible = toggle

func _on_reset_pressed() -> void:
	_toggle_confirm_box(true)

func _on_yes_pressed() -> void:
	_reset_info()
	_toggle_confirm_box(false)

func _on_no_pressed() -> void:
	_toggle_confirm_box(false)

func _on_close_pressed() -> void:
	self.visible = false
