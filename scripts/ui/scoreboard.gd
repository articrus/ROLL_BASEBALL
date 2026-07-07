extends Control
# Info labels
@onready var strikesLabel = $Panel/InnerPanel/InfoContainer/Strikes
@onready var inningCount = $Panel/InnerPanel/TeamScore/InningCount
# Score Labels
@onready var homePoints = $Panel/InnerPanel/TeamScore/HomeScore
@onready var homeTotal = $Panel/InnerPanel/TeamScore/HomeTotal
@onready var visitorPoints = $Panel/InnerPanel/TeamScore/VisitorScore
@onready var visitorTotal = $Panel/InnerPanel/TeamScore/VisitorTotal

func _ready() -> void:
	_connect_signals()

# Updates the score label
func _update_score(home: Array[int], visit: Array[int]) -> void:
	var homeText = ""
	var visitText = ""
	var homePT = 0
	var visitPT = 0
	for i in range(1, 9):
		homePT += home[i]
		visitPT += visit[i]
		homeText += "[" + str(home[i]) + "] "
		visitText += "[" + str(visit[i]) + "] "
	homePoints.text = homeText
	visitorPoints.text = visitText
	homeTotal.text = "[" + str(homePT) + "]"
	visitorTotal.text = "[" + str(visitPT) + "]"

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

# Highlight the current inning
func _update_inning_display(inning: int) -> void:
	var inningText = ""
	for i in range(1, 9):
		if i == inning:
			inningText += "[color=blue][" + str(i) + "][/color] "
		else:
			inningText += "[" + str(i) + "] "
	inningCount.text = inningText

func _connect_signals() -> void:
	Signalbus.update_strikes.connect(_update_strikeouts)
	Signalbus.update_points.connect(_update_score)
	Signalbus.update_inning.connect(_update_inning_display)
