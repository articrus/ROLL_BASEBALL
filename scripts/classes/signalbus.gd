@warning_ignore("unused_signal")
extends Node

# Game Signals
signal bat_pressed
signal pitch_pressed
signal roll_to_bat(left: Enums.DIE_TYPES, right: Enums.DIE_TYPES)
signal roll_to_pitch(left: Enums.DIE_TYPES, right: Enums.DIE_TYPES)

# Logging In
signal user_login

# Team Select
signal team_highlight(city: Enums.CITY)
signal team_selected(city: Enums.CITY)

# Temporary Signals
signal display_batting_result(result: String)
signal display_points(player: int, com: int)
signal update_inning(inning: int)
