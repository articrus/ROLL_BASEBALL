@warning_ignore("unused_signal")
extends Node

# Game Signals
signal start_game
signal roll_button_pressed
signal process_roll(left: Enums.DIE_TYPES, right: Enums.DIE_TYPES)
signal special_pressed
signal game_over(home: int, visit: int, average: float, victory: bool)

# Logging In
signal user_login

# Team Select
signal team_highlight(city: Enums.CITY)
signal team_selected(city: Enums.CITY)

# Scoreboard Signals
signal update_inning_info(strikeDC: int, specialDC: int)
signal update_strikes(strikes: int)
signal update_points(homeArray: Array[int], visitArray: Array[int])

# Temporary Signals
signal display_batting_result(result: String)
signal update_inning(inning: int)
