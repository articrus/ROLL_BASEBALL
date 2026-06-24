@warning_ignore("unused_signal")
extends Node

# Game Signals
signal roll_button_pressed
signal process_roll(left: Enums.DIE_TYPES, right: Enums.DIE_TYPES)
signal special_pressed

# Logging In
signal user_login

# Team Select
signal team_highlight(city: Enums.CITY)
signal team_selected(city: Enums.CITY)

# Temporary Signals
signal display_batting_result(result: String)
signal display_points(player: int, com: int)
signal update_inning(inning: int)
