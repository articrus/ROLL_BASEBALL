extends TextureRect
@onready var infoText = {
	"Wins": $Panel/HBoxContainer/WinsText,
	"Total": $Panel/HBoxContainer/ToalPoints,
	"Average": $Panel/HBoxContainer/AveragePoints
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
	SoundManager._play_button()
	_toggle_confirm_box(true)

func _on_yes_pressed() -> void:
	SoundManager._play_button()
	_reset_info()
	_toggle_confirm_box(false)

func _on_no_pressed() -> void:
	SoundManager._play_button()
	_toggle_confirm_box(false)

func _on_close_pressed() -> void:
	SoundManager._play_button()
	self.visible = false
