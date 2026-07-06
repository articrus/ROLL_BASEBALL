@warning_ignore("unused_signal")
extends Node

# Game Signals
signal start_game
signal roll_button_pressed
signal process_roll(left: Enums.DIE_TYPES, right: Enums.DIE_TYPES)
signal special_pressed
signal game_over(home: int, visit: int, average: float, victory: bool)
signal disable_roll(toggle: bool)

# Logging In
signal user_login

# Team Select
signal team_highlight(city: Enums.CITY)
signal team_selected(city: Enums.CITY)

# Scoreboard Signals
signal update_inning_info(strikeDC: int, specialDC: int)
signal update_strikes(strikes: int)
signal update_points(homeArray: Array[int], visitArray: Array[int])
signal display_batting_result(result: String)

# Dice Rolling
signal update_die_faces(leftType: Enums.DIE_TYPES, leftResult: int, rightType: Enums.DIE_TYPES, rightResult: int)

# Figure out with this one
signal update_inning(inning: int)
