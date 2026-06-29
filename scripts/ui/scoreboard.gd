extends Control
# Info labels
@onready var strikeDCLabel = $Panel/InnerPanel/InfoContainer/DCInfo
@onready var specialDClabel = $Panel/InnerPanel/InfoContainer/Special
@onready var strikesLabel = $Panel/InnerPanel/InfoContainer/Strikes
# Score Labels
@onready var homePoints = $"Panel/InnerPanel/Team Score/HomeScore"
@onready var homeTotal = $"Panel/InnerPanel/Team Score/HomeTotal"
@onready var visitorPoints = $"Panel/InnerPanel/Team Score/VisitorScore"
@onready var visitorTotal = $"Panel/InnerPanel/Team Score/VisitorTotal"

func _ready() -> void:
	_connect_signals()

# Updates the score label
func _update_score(inning: int, score: int) -> void:
	if inning % 2 == 0:
		print("ENEMY SCORE: ", str(score))
	else:
		print("HOME SCORE:", str(score))

# Update info label
func _update_info(strikeDC: int, specialDC: int) -> void:
	strikeDCLabel.text = "Strike DC [" + str(strikeDC) + "]"
	specialDClabel.text = "Special DC [" + str(specialDC) + "]"

# Updates the strikeouts on the scoreboard
func _update_strikeouts(strikes: int) -> void:
	match strikes:
		0:
			strikesLabel.text = "Out [ ] [ ] [ ]"
		1:
			strikesLabel.text = "Out [X] [ ] [ ]"
		2:
			strikesLabel.text = "Out [X] [X] [ ]"
		3:
			strikesLabel.text = "Out [X] [X] [X]"
		_: # Failsafe
			strikesLabel.text = "Out [ ] [ ] [ ]"

func _connect_signals() -> void:
	Signalbus.update_strikes.connect(_update_strikeouts)
	Signalbus.update_inning_info.connect(_update_info)
