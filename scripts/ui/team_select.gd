extends Control
@onready var teamButtons = {
	Enums.CITY.MTL: $TeamsBoxes/TeamsA/MTL,
	Enums.CITY.TOR: $TeamsBoxes/TeamsB/TOR,
	Enums.CITY.MIA: $TeamsBoxes/TeamsA/MIA,
	Enums.CITY.SAJOS: $TeamsBoxes/TeamsB/SAJO,
	Enums.CITY.LA: $TeamsBoxes/TeamsA/LA,
	Enums.CITY.CHI: $TeamsBoxes/TeamsB/CHI,
	Enums.CITY.BOS: $TeamsBoxes/TeamsA/BOS,
	Enums.CITY.SAFRA: $TeamsBoxes/TeamsB/SAFR,
	Enums.CITY.SADIE: $TeamsBoxes/TeamsA/SADI,
	Enums.CITY.KH: $TeamsBoxes/TeamsB/KH,
	Enums.CITY.DEN: $TeamsBoxes/TeamsA/DEN,
	Enums.CITY.NY: $TeamsBoxes/TeamsB/NY
}
@onready var teamNameTag = $TeamInfo/TeamName
@onready var teamCityTag = $TeamInfo/City

func _ready() -> void:
	_bind_buttons()
	Signalbus.team_highlight.connect(_display_team_text)

func _bind_buttons() -> void:
	teamButtons[Enums.CITY.MTL].pressed.connect(_on_team_pressed.bind(Enums.CITY.MTL))
	teamButtons[Enums.CITY.TOR].pressed.connect(_on_team_pressed.bind(Enums.CITY.TOR))
	teamButtons[Enums.CITY.MIA].pressed.connect(_on_team_pressed.bind(Enums.CITY.MIA))
	teamButtons[Enums.CITY.SAJOS].pressed.connect(_on_team_pressed.bind(Enums.CITY.SAJOS))
	teamButtons[Enums.CITY.LA].pressed.connect(_on_team_pressed.bind(Enums.CITY.LA))
	teamButtons[Enums.CITY.CHI].pressed.connect(_on_team_pressed.bind(Enums.CITY.CHI))
	teamButtons[Enums.CITY.BOS].pressed.connect(_on_team_pressed.bind(Enums.CITY.BOS))
	teamButtons[Enums.CITY.SAFRA].pressed.connect(_on_team_pressed.bind(Enums.CITY.SAFRA))
	teamButtons[Enums.CITY.SADIE].pressed.connect(_on_team_pressed.bind(Enums.CITY.SADIE))
	teamButtons[Enums.CITY.KH].pressed.connect(_on_team_pressed.bind(Enums.CITY.KH))
	teamButtons[Enums.CITY.DEN].pressed.connect(_on_team_pressed.bind(Enums.CITY.DEN))
	teamButtons[Enums.CITY.NY].pressed.connect(_on_team_pressed.bind(Enums.CITY.NY))

func _on_team_pressed(city: Enums.CITY) -> void:
	Signalbus.team_selected.emit(city)
	Signalbus.start_game.emit()
	_close_team_select()

func _display_team_text(city: Enums.CITY) -> void:
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
