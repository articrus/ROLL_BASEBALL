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
		if players[2] != null: # Third advances to Home
			players[2]._set_player_position(bases._get_base_position(3))
			players[2] = null
		if players[1] != null: # Second advances to Third
			players[1]._set_player_position(bases._get_base_position(2))
			players[2] = players[1]
			players[1] = null
		if players[0] != null: # First advances to Second
			players[0]._set_player_position(bases._get_base_position(1))
			players[1] = players[0]
			players[0] = null
		if players[3] != null: # Batter advances to First
			players[3]._set_player_position(bases._get_base_position(0))
			players[0] = players[3]
			players[3] = null
		await get_tree().process_frame
	_add_player_to_bat(batTeam)

func _strikeout() -> void:
	players[3]._set_player_position(bases._get_out_position())
	players[3] = null
	_add_player_to_bat(batTeam)

func _add_player_to_bat(team: Enums.CITY) -> void:
	var newPlayer = player.instantiate()
	add_child(newPlayer)
	newPlayer._set_team_color(team)
	newPlayer.global_position = bases._get_spawn_position()  # Set to home plate
	players[3] = newPlayer
	newPlayer._set_player_position(bases._get_base_position(3))

func _add_player_to_pitch(team: Enums.CITY) -> void:
	var newPlayer = player.instantiate()
	add_child(newPlayer)
	newPlayer._set_team_color(team)
	newPlayer.global_position = bases._get_pitch_position()

func _clear_the_field() -> void:
	# Have them lerp to out, but for now, just queue free
	for actor in self.get_children():
		actor._set_player_position(bases._get_out_position())
	_clear_players_dictionary()

func _clear_players_dictionary() -> void:
	players[0] = null
	players[1] = null
	players[2] = null
	players[3] = null
