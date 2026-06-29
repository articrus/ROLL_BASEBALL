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
const specialDC: Array[int] = [0, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7]
# Signals
signal advance_bases(amount: int)
signal strikeout
signal toggle_special(toggle: bool)

# Connect any necessary signals
func _ready() -> void:
	_connect_signals()
	Signalbus.update_inning_info.emit(strikeDC[current_inning], specialDC[current_inning])

# Process the roll and update the gamestate
func _process_rolling(left_die: Enums.DIE_TYPES, right_die: Enums.DIE_TYPES) -> void:
	# Fix the result grabber
	var result
	if current_inning % 2 == 0:
		result = Dice._process_pitching(left_die, right_die, strikeDC[current_inning])
	else:
		result = Dice._process_batting(left_die, right_die, strikeDC[current_inning])
	var runs = 0
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

# Attempt to steal the furthest base (returns points)
func _steal_base() -> int:
	var result = Dice._roll_die(6) + Dice._roll_die(6)
	if result >= specialDC[current_inning]:
		# In each one call a special advance bases
		# Third steals home and scores
		if bases[2]:
			bases[2] = false
			return 1
		# Second steals third
		elif bases[1]:
			bases[1] = false
			bases[2] = true
			return 0
		# First steals second
		else:
			bases[1] = true
			bases[0] = false
			return 0
	else:
		strikeouts += 1
		_check_strikes()
		return 0

# Attempt to tag out the furthest player (returns strikeouts)
func _tag_out() -> void:
	# Tag out third base
	if bases[2]:
		bases[2] = false
	# Tag out second base
	elif bases[1]:
		bases[1] = false
	# Tag out first base
	else:
		bases[0] = false
	strikeouts += 1

func _special_pressed() -> void:
	if current_inning % 2 == 0:
		_tag_out()
		_check_strikes()
	else:
		homePointsArray[current_inning] += _steal_base()
	Signalbus.update_points.emit(homePointsArray, visitPointsArray)

func _toggle_special_buttons() -> void:
	toggle_special.emit(!(bases[2] == true || bases[1] == true || bases[0] == true))

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

func _game_over() -> void:
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
