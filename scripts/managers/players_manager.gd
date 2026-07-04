extends Node2D
@onready var player = load("res://actors/player.tscn")
@export var players = {
	0: null, # First
	1: null, # Second
	2: null, # Third
	3: null # Home Plate
}
var bases # Reference to bases
var batTeam: Enums.CITY

func _advance_bases(amount: int) -> void:
	for i in amount:
		var tweens: Array = []
		if players[2] != null: # Third advances to Home
			tweens.append(players[2]._return_home(bases._get_score_position()))
			players[2] = null
		if players[1] != null: # Second advances to Third
			tweens.append(players[1]._set_player_position(bases._get_base_position(2)))
			players[2] = players[1]
			players[1] = null
		if players[0] != null: # First advances to Second
			tweens.append(players[0]._set_player_position(bases._get_base_position(1)))
			players[1] = players[0]
			players[0] = null
		if players[3] != null: # Batter advances to First
			tweens.append(players[3]._set_player_position(bases._get_base_position(0)))
			players[0] = players[3]
			players[3] = null
		for tween in tweens:
			await tween.finished
	_add_player_to_bat(batTeam)

# Advance one player one base, used in steal and tag out
func _advance_one_player(baseNumber: int) -> void:
	if baseNumber > 3 || baseNumber < 0: return
	if players[baseNumber] != null:
		if baseNumber < 2:
			players[baseNumber]._set_player_position(bases._get_base_position(baseNumber + 1))
			players[baseNumber + 1] = players[baseNumber]
			players[baseNumber] = null
		else:
			players[baseNumber]._return_home(bases._get_score_position())
			players[baseNumber] = null

# Tags out/removes one player
func _out_one_player(baseNumber: int) -> void:
	if baseNumber > 3 || baseNumber < 0: return
	if players[baseNumber] != null:
		players[baseNumber]._strikeout(bases._get_out_position())
		players[baseNumber] = null

func _strikeout() -> void:
	players[3]._strikeout(bases._get_out_position())
	players[3] = null
	_add_player_to_bat(batTeam)

func _add_player_to_bat(team: Enums.CITY) -> void:
	var newPlayer = player.instantiate()
	add_child(newPlayer)
	newPlayer._setup_player(team, true)
	newPlayer.global_position = bases._get_spawn_position()  # Set to home plate
	players[3] = newPlayer
	await newPlayer._set_player_position(bases._get_base_position(3))
	Signalbus.disable_roll.emit(false)

func _add_player_to_pitch(team: Enums.CITY) -> void:
	var newPlayer = player.instantiate()
	add_child(newPlayer)
	newPlayer._setup_player(team, false)
	newPlayer.global_position = bases._get_pitch_position()
	newPlayer.z_index = 5 # Ensure pitchers are in front

func _clear_the_field() -> void:
	for actor in self.get_children():
		actor._strikeout(bases._get_out_position())
	_clear_players_dictionary()

func _clear_players_dictionary() -> void:
	players[0] = null
	players[1] = null
	players[2] = null
	players[3] = null
