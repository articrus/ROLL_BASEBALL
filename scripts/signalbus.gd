extends Node

signal bat_pressed
signal pitch_pressed
signal roll_to_bat(left: Enums.DIE_TYPES, right: Enums.DIE_TYPES)
signal roll_to_pitch(left: Enums.DIE_TYPES, right: Enums.DIE_TYPES)

# Temporary Signals
signal display_batting_result(result: String)
signal display_points(player: int, com: int)
signal update_inning(inning: int)
