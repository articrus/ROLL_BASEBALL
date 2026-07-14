extends Node2D
@onready var bases = $Bases
@onready var playerManager = $Players
@onready var gameManager = $GameManager
@onready var gameUI = $CanvasLayer/PlayerUI
@onready var baseBall = load("res://actors/objects/base_ball.tscn")
# Export and other vars
var playerTeam: Enums.CITY
var enemyTeam: Enums.CITY

func _ready() -> void:
	playerManager.bases = bases
	gameManager.basePositions = bases
	_connect_signals()

# Start a new inning
func _start_inning(inning: int) -> void:
	_clear_field()
	if inning % 2 == 0:
		# Enemy Bats
		playerManager._add_player_to_bat(enemyTeam)
		playerManager._add_player_to_pitch(playerTeam)
		playerManager.batTeam = enemyTeam
		playerManager._add_players_to_field(playerTeam)
	else: 
		# Player Bats
		playerManager._add_player_to_bat(playerTeam)
		playerManager._add_player_to_pitch(enemyTeam)
		playerManager.batTeam = playerTeam
		playerManager._add_players_to_field(enemyTeam)

func _pitch_the_ball(homePos: Vector2, endPos: Vector2) -> void:
	var newBall = baseBall.instantiate()
	add_child(newBall)
	newBall._pitch_ball(homePos, endPos)

func _clear_field() -> void:
	playerManager._clear_the_field()

func _set_teams(team: Enums.CITY) -> void:
	playerTeam = team
	var rand = randi_range(0, Enums.CITY.size()-1)
	if rand as Enums.CITY == playerTeam:
		rand += 1
		if rand > Enums.CITY.size():
			rand = 0
	enemyTeam = rand as Enums.CITY
	_start_inning(gameManager.current_inning)

func _connect_signals() -> void:
	gameManager.advance_bases.connect(playerManager._advance_bases)
	gameManager.strikeout.connect(playerManager._strikeout)
	gameManager.toggle_special.connect(gameUI._disable_special)
	gameManager.advance_one_base.connect(playerManager._advance_one_player)
	gameManager.strike_one_base.connect(playerManager._out_one_player)
	Signalbus.update_inning.connect(_start_inning)
	Signalbus.team_selected.connect(_set_teams)
	Signalbus.pitch_ball.connect(_pitch_the_ball)
