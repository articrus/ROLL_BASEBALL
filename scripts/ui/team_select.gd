extends Control
@onready var teamButtons = {
	Enums.CITY.MTL: $VBoxContainer/TeamsBoxes/TeamsA/MTL,
	Enums.CITY.TOR: $VBoxContainer/TeamsBoxes/TeamsB/TOR,
	Enums.CITY.MIA: $VBoxContainer/TeamsBoxes/TeamsA/MIA,
	Enums.CITY.SAJOS: $VBoxContainer/TeamsBoxes/TeamsB/SAJO,
	Enums.CITY.LA: $VBoxContainer/TeamsBoxes/TeamsA/LA,
	Enums.CITY.CHI: $VBoxContainer/TeamsBoxes/TeamsB/CHI,
	Enums.CITY.BOS: $VBoxContainer/TeamsBoxes/TeamsA/BOS,
	Enums.CITY.SAFRA: $VBoxContainer/TeamsBoxes/TeamsB/SAFR,
	Enums.CITY.SADIE: $VBoxContainer/TeamsBoxes/TeamsA/SADI,
	Enums.CITY.KH: $VBoxContainer/TeamsBoxes/TeamsB/KH,
	Enums.CITY.DEN: $VBoxContainer/TeamsBoxes/TeamsA/DEN,
	Enums.CITY.NY: $VBoxContainer/TeamsBoxes/TeamsB/NY
}
@onready var teamLogo = $VBoxContainer/TeamLogo
@onready var teamNameTag = $VBoxContainer/TeamInfo/TeamName
@onready var teamCityTag = $VBoxContainer/TeamInfo/City
# Team Logos
@onready var teamLogos = {
	Enums.CITY.MTL: "PATH STRING"
}

func _ready() -> void:
	_bind_buttons()
	Signalbus.team_highlight.connect(_display_team_text)

func _bind_buttons() -> void:
	for city in teamButtons:
		teamButtons[city].pressed.connect(_on_team_pressed.bind(city))
	#teamButtons[Enums.CITY.MTL].pressed.connect(_on_team_pressed.bind(Enums.CITY.MTL))
	#teamButtons[Enums.CITY.TOR].pressed.connect(_on_team_pressed.bind(Enums.CITY.TOR))
	#teamButtons[Enums.CITY.MIA].pressed.connect(_on_team_pressed.bind(Enums.CITY.MIA))
	#teamButtons[Enums.CITY.SAJOS].pressed.connect(_on_team_pressed.bind(Enums.CITY.SAJOS))
	#teamButtons[Enums.CITY.LA].pressed.connect(_on_team_pressed.bind(Enums.CITY.LA))
	#teamButtons[Enums.CITY.CHI].pressed.connect(_on_team_pressed.bind(Enums.CITY.CHI))
	#teamButtons[Enums.CITY.BOS].pressed.connect(_on_team_pressed.bind(Enums.CITY.BOS))
	#teamButtons[Enums.CITY.SAFRA].pressed.connect(_on_team_pressed.bind(Enums.CITY.SAFRA))
	#teamButtons[Enums.CITY.SADIE].pressed.connect(_on_team_pressed.bind(Enums.CITY.SADIE))
	#teamButtons[Enums.CITY.KH].pressed.connect(_on_team_pressed.bind(Enums.CITY.KH))
	#teamButtons[Enums.CITY.DEN].pressed.connect(_on_team_pressed.bind(Enums.CITY.DEN))
	#teamButtons[Enums.CITY.NY].pressed.connect(_on_team_pressed.bind(Enums.CITY.NY))

func _on_team_pressed(city: Enums.CITY) -> void:
	Signalbus.team_selected.emit(city)
	Signalbus.start_game.emit()
	_close_team_select()

func _display_team_text(city: Enums.CITY) -> void:
	teamLogo.visible = true
	teamLogo.modulate = Enums.CITY_COLORS[city]
	#teamLogo.texture = teamLogos[city]
	match city:
		Enums.CITY.MTL:
			teamNameTag.text = "Mile-End Baristas"
			teamCityTag.text = "Montreal"
			teamLogo.modulate = Enums.CITY_COLORS[city]
		Enums.CITY.TOR:
			teamNameTag.text = "Christie Pits Runners"
			teamCityTag.text = "Toronto"
		Enums.CITY.MIA:
			teamNameTag.text = "South Beach Crocodiles"
			teamCityTag.text = "Miami"
		Enums.CITY.SAJOS:
			teamNameTag.text = "Silicon Valley Chippers"
			teamCityTag.text = "San Jose"
		Enums.CITY.LA:
			teamNameTag.text = "Orange County Surfers"
			teamCityTag.text = "Los Angeles"
		Enums.CITY.CHI:
			teamNameTag.text = "Lincoln Park Niners"
			teamCityTag.text = "Chicago"
		Enums.CITY.BOS:
			teamNameTag.text = "Beacon Hill Climbers"
			teamCityTag.text = "Boston"
		Enums.CITY.SAFRA:
			teamNameTag.text = "Embarcadero Seals"
			teamCityTag.text = "San Francisco"
		Enums.CITY.SADIE:
			teamNameTag.text = "La Jolla Innovators"
			teamCityTag.text = "San Diego"
		Enums.CITY.KH:
			teamNameTag.text = "Outer Banks Aviators"
			teamCityTag.text = "Kitty Hawk SC"
		Enums.CITY.DEN:
			teamNameTag.text = "Mile High Miners"
			teamCityTag.text = "Denver"
		Enums.CITY.NY:
			teamNameTag.text = "Soho Anvils"
			teamCityTag.text = "New York"

func _close_team_select() -> void:
	# Play an advertisement here
	self.visible = false
