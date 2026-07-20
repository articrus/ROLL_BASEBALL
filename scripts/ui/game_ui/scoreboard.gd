extends Control
# Info labels
@onready var strikesLabel = $Panel/InnerPanel/InfoContainer/Strikes
@onready var inningCount = $Panel/InnerPanel/TeamScore/InningCount
@onready var homeTeam = $Panel/InnerPanel/TeamScore/HomeTeam
@onready var visitTeam = $Panel/InnerPanel/TeamScore/VisitorTeam
# Score Labels
@onready var homePoints = $Panel/InnerPanel/TeamScore/HomeScore
@onready var homeTotal = $Panel/InnerPanel/TeamScore/HomeTotal
@onready var visitorPoints = $Panel/InnerPanel/TeamScore/VisitorScore
@onready var visitorTotal = $Panel/InnerPanel/TeamScore/VisitorTotal
# Inning reference
var inningRef = 1

func _ready() -> void:
	_connect_signals()

# Updates the score label
func _update_score(home: Array[int], visit: Array[int]) -> void:
	var homeText = ""
	var visitText = ""
	var homePT = 0
	var visitPT = 0
	for i in range(1, 10):
		homePT += home[i]
		visitPT += visit[i]
		if i == inningRef:
			homeText += "[color=blue][" + str(home[i]) + "][/color] "
			visitText += "[color=blue][" + str(visit[i]) + "][/color] "
		else:
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
	inningRef = inning
	for i in range(1, 10):
		if i == inning:
			inningText += "[color=blue][" + str(i) + "][/color] "
		else:
			inningText += "[" + str(i) + "] "
	inningCount.text = inningText

func _get_team_name(city: Enums.CITY) -> String:
	match city:
		Enums.CITY.MTL: return "Montreal"
		Enums.CITY.TOR: return "Toronto"
		Enums.CITY.MIA: return "Miami"
		Enums.CITY.SAJOS: return "San Jose"
		Enums.CITY.LA: return "LA"
		Enums.CITY.CHI: return "Chicago"
		Enums.CITY.BOS: return "Boston"
		Enums.CITY.SAFRA: return "San Fran."
		Enums.CITY.SADIE: return "San Diego"
		Enums.CITY.KH: return "Kitty Hawk"
		Enums.CITY.DEN: return "Denver"
		Enums.CITY.NY: return "New York"
		_: return "ERROR"

# Sets the team names on the scoreboard
func _set_team_names(home: Enums.CITY, visit: Enums.CITY) -> void:
	homeTeam.text = _get_team_name(home)
	visitTeam.text = _get_team_name(visit)

func _connect_signals() -> void:
	Signalbus.update_scoreboard_names.connect(_set_team_names)
	Signalbus.update_strikes.connect(_update_strikeouts)
	Signalbus.update_points.connect(_update_score)
	Signalbus.update_inning.connect(_update_inning_display)
