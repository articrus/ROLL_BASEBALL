extends TextureRect
@onready var teamButtons = {
	Enums.CITY.MTL: $Panel/VBoxContainer/TeamsBoxes/TeamsA/MTL,
	Enums.CITY.TOR: $Panel/VBoxContainer/TeamsBoxes/TeamsB/TOR,
	Enums.CITY.MIA: $Panel/VBoxContainer/TeamsBoxes/TeamsA/MIA,
	Enums.CITY.SAJOS: $Panel/VBoxContainer/TeamsBoxes/TeamsB/SAJO,
	Enums.CITY.LA: $Panel/VBoxContainer/TeamsBoxes/TeamsA/LA,
	Enums.CITY.CHI: $Panel/VBoxContainer/TeamsBoxes/TeamsB/CHI,
	Enums.CITY.BOS: $Panel/VBoxContainer/TeamsBoxes/TeamsA/BOS,
	Enums.CITY.SAFRA: $Panel/VBoxContainer/TeamsBoxes/TeamsB/SAFR,
	Enums.CITY.SADIE: $Panel/VBoxContainer/TeamsBoxes/TeamsA/SADI,
	Enums.CITY.KH: $Panel/VBoxContainer/TeamsBoxes/TeamsB/KH,
	Enums.CITY.DEN: $Panel/VBoxContainer/TeamsBoxes/TeamsA/DEN,
	Enums.CITY.NY: $Panel/VBoxContainer/TeamsBoxes/TeamsB/NY
}
@onready var teamLogo = $Panel/VBoxContainer/TeamLogo
@onready var teamNameTag = $Panel/VBoxContainer/TeamInfo/TeamName
@onready var teamCityTag = $Panel/VBoxContainer/TeamInfo/City
# Team Logos
@onready var teamLogos = {
	Enums.CITY.MTL: load("res://art/logos/baristas-512x512.png"),
	Enums.CITY.TOR: load("res://art/logos/runners-512x512.png"),
	Enums.CITY.MIA: load("res://art/logos/crocodiles-512x512.png"),
	Enums.CITY.SAJOS: load("res://art/logos/chippers-512x512.png"),
	Enums.CITY.LA: load("res://art/logos/surfers-512x512.png"),
	Enums.CITY.CHI: load("res://art/logos/niners-512x512.png"),
	Enums.CITY.BOS: load("res://art/logos/climbers-512x512.png"),
	Enums.CITY.SAFRA: load("res://art/logos/seals-512x512.png"),
	Enums.CITY.SADIE: load("res://art/logos/innovatorss-512x512.png"),
	Enums.CITY.KH: load("res://art/logos/aviators-512x512.png"),
	Enums.CITY.DEN: load("res://art/logos/miners-512x512.png"),
	Enums.CITY.NY: load("res://art/logos/anvils-512x512.png")
}

func _ready() -> void:
	_bind_buttons()
	Signalbus.team_highlight.connect(_display_team_text)
	teamButtons[Enums.CITY.MTL].grab_focus()

func _bind_buttons() -> void:
	for city in teamButtons:
		teamButtons[city].pressed.connect(_on_team_pressed.bind(city))

func _on_team_pressed(city: Enums.CITY) -> void:
	Signalbus.team_selected.emit(city)
	Signalbus.start_game.emit()
	_close_team_select()

func _display_team_text(city: Enums.CITY) -> void:
	teamLogo.visible = true
	teamLogo.texture = teamLogos[city]
	match city:
		Enums.CITY.MTL:
			teamNameTag.text = "Mile-End Baristas"
			teamCityTag.text = "Montreal"
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
