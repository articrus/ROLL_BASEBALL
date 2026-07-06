extends Node
class_name GameManager
# 0: First, 1: Second, 2: Third, if occupied: true, else false
@export var bases: Array[bool] = [false, false, false]
# Points variables
@export var homePointsArray: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
@export var visitPointsArray: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
@export var strikeouts: int = 0
# Inning Variables
@export var current_inning: int = 1
# DC Variables
const strikeDC: Array[int] = [0, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7]
const specialDC: Array[int] = [0, 0, 0, 10, 10, 10, 10, 10, 10, 10, 10]
# Signals
signal advance_bases(amount: int)
signal strikeout
signal toggle_special(toggle: bool)
# Special
signal advance_one_base(baseNumber: int)
signal strike_one_base(baseNumber: int)

# Connect any necessary signals
func _ready() -> void:
	_connect_signals()
	Signalbus.update_inning_info.emit(strikeDC[current_inning], specialDC[current_inning])

# Process the roll and update the gamestate
func _process_rolling(left_die: Enums.DIE_TYPES, right_die: Enums.DIE_TYPES) -> void:
	Signalbus.disable_roll.emit(true)
	# Fix the result grabber
	var result
	if current_inning % 2 == 0:
		result = Dice._process_pitching(left_die, right_die, strikeDC[current_inning])
	else:
		result = Dice._process_batting(left_die, right_die, strikeDC[current_inning])
	var runs = 0
	await Signalbus.resume_processing
	match result[1]:
		Enums.BATTING_RESULT.HOMERUN:
			Signalbus.display_batting_result.emit("HOME RUN!")
			runs += _advance_base(4)
			advance_bases.emit(4)
		Enums.BATTING_RESULT.TRIPLE:
			Signalbus.display_batting_result.emit("TRIPLE!")
			runs += _advance_base(3)
			advance_bases.emit(3)
		Enums.BATTING_RESULT.DOUBLE:
			Signalbus.display_batting_result.emit("DOUBLE!")
			runs += _advance_base(2)
			advance_bases.emit(2)
		Enums.BATTING_RESULT.SINGLE:
			Signalbus.display_batting_result.emit("SINGLE!")
			runs += _advance_base(1)
			advance_bases.emit(1)
		Enums.BATTING_RESULT.STRIKEOUT:
			Signalbus.display_batting_result.emit("STRIKEOUT!")
			strikeouts += 1
			strikeout.emit()
	# Add the points
	if current_inning % 2 == 0: 
		visitPointsArray[current_inning] += runs
	else: 
		homePointsArray[current_inning] += runs
	Signalbus.update_points.emit(homePointsArray, visitPointsArray)
	_toggle_special_buttons()
	_check_strikes()

# Advances any players on bases by the given amount
func _advance_base(amount: int) -> int:
	var points = 0
	for i in amount:
		if bases[2]: points += 1
		bases[2] = bases[1]
		bases[1] = bases[0]
		bases[0] = (i == 0) # The batter leaving the home plate in the first loop
	return points

# Gets the furthest occupied base
func _furthest_occupied_base() -> int:
	if bases[2]: return 2
	if bases[1]: return 1
	if bases[0]: return 0
	return -1

# Attempt to steal the furthest base (returns points)
func _steal_base() -> int:
	var base = _furthest_occupied_base()
	if base == -1: return 0 # Prevent stealing with no players on bases
	bases[base] = false
	if Dice._roll_die(6) + Dice._roll_die(6) >= specialDC[current_inning]:
		advance_one_base.emit(base)
		if base < 2:
			bases[base + 1] = true # Advance to next base
			Signalbus.display_batting_result.emit("STEAL!")
			return 0
		else:
			Signalbus.display_batting_result.emit("POINT STOLEN!")
			return 1 # Stole home base, stole a point
	else:
		strike_one_base.emit(base)
		strikeouts += 1
		Signalbus.display_batting_result.emit("OUT!")
		return 0

# Attempt to tag out the furthest player (returns strikeouts)
func _tag_out() -> int:
	var base = _furthest_occupied_base()
	if base == -1: return 0 # Prevent tagging out with no players on bases
	bases[base] = false
	if Dice._roll_die(6) + Dice._roll_die(6) >= specialDC[current_inning]:
		strike_one_base.emit(base)
		Signalbus.display_batting_result.emit("TAG OUT!")
		strikeouts += 1
		return 0
	else:
		if base < 2:
			bases[base + 1] = true
			advance_one_base.emit(base)
			Signalbus.display_batting_result.emit("POINT STOLEN!")
			return 0
		else:
			advance_one_base.emit(base)
			Signalbus.display_batting_result.emit("STEAL!")
			return 1

func _special_pressed() -> void:
	if current_inning % 2 == 0:
		visitPointsArray[current_inning] += _tag_out()
		_check_strikes()
	else:
		homePointsArray[current_inning] += _steal_base()
		_check_strikes()
	_toggle_special_buttons()
	Signalbus.update_points.emit(homePointsArray, visitPointsArray)

func _toggle_special_buttons() -> void:
	toggle_special.emit(_furthest_occupied_base() == -1)

# Check strikeouts check 
func _check_strikes() -> void:
	Signalbus.update_strikes.emit(strikeouts)
	if strikeouts >= 3:
		if current_inning >= 9:
			_game_over()
			# Call gameover splash screen
		else:
			Signalbus.display_batting_result.emit("CHANGE SIDES!")
			_next_inning()

# Reset all the bases
func _reset_bases() -> void:
	for i in bases.size():
		bases[i] = false

# Advance to the next inning
func _next_inning() -> void:
	_reset_bases()
	strikeouts = 0
	Signalbus.update_strikes.emit(strikeouts)
	current_inning += 1
	if current_inning > 9:
		current_inning = 1
	Signalbus.update_inning.emit(current_inning)
	Signalbus.update_inning_info.emit(strikeDC[current_inning], specialDC[current_inning])
	Signalbus.disable_roll.emit(false)

func _game_over() -> void:
	Signalbus.disable_roll.emit(true)
	var homePoints = 0
	var visitPoints = 0
	for i in range(1, 9):
		homePoints += homePointsArray[i]
		visitPoints += visitPointsArray[i]
	var average = homePoints / 5.0 # Average points scored by player per inning
	# Save the stats
	var profile = await AuthenticationManager._load_profile()
	var newWins = profile.get("games_won", 0) + 1
	var newTotal = profile.get("points_scored", 0) + homePoints
	AuthenticationManager._save_stats({"games_won": newWins, "points_scored": newTotal, "average_points_per": average})
	Signalbus.game_over.emit(homePoints, visitPoints, average, homePoints > visitPoints)
	Signalbus.display_batting_result.emit("GAME OVER!")

func _game_start() -> void:
	_reset_bases()
	strikeouts = 0
	current_inning = 1
	Signalbus.update_points.emit(homePointsArray, visitPointsArray)
	Signalbus.update_inning_info.emit(strikeDC[current_inning], specialDC[current_inning])

func _connect_signals() -> void:
	Signalbus.start_game.connect(_game_start)
	Signalbus.process_roll.connect(_process_rolling)
	Signalbus.special_pressed.connect(_special_pressed)
