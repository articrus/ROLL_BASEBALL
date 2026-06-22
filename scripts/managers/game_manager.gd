extends Node
class_name GameManager
# 0: First, 1: Second, 2: Third, if occupied: true, else false
@export var bases: Array[bool] = [false, false, false]
# Points variables
@export var home_points: int = 0
@export var visitor_points: int = 0
@export var points_scored_this_inning: int = 0
@export var strikeouts: int = 0
# Inning Variables
@export var current_inning: int = 1
# DC Variables
const strikeDC: Array[int] = [0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7]
const specialDC: Array[int] = [0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7]
# Signals
signal advance_bases(amount: int)
signal strikeout
signal toggle_special(toggle: bool)

# Connect any necessary signals
func _ready() -> void:
	_connect_signals()

# Process the result of batting
func _process_batting(left_die: Enums.DIE_TYPES, right_die: Enums.DIE_TYPES) -> void:
	var result = Dice._process_batting(left_die, right_die, strikeDC[current_inning])
	match(result[1]):
		Enums.BATTING_RESULT.HOMERUN:
			Signalbus.display_batting_result.emit("HOME RUN!")
			home_points += _advance_base(4)
			advance_bases.emit(4)
		Enums.BATTING_RESULT.TRIPLE:
			Signalbus.display_batting_result.emit("TRIPLE!")
			home_points += _advance_base(3)
			advance_bases.emit(3)
		Enums.BATTING_RESULT.DOUBLE:
			Signalbus.display_batting_result.emit("DOUBLE!")
			home_points += _advance_base(2)
			advance_bases.emit(2)
		Enums.BATTING_RESULT.SINGLE:
			Signalbus.display_batting_result.emit("SINGLE!")
			home_points += _advance_base(1)
			advance_bases.emit(1)
		Enums.BATTING_RESULT.STRIKEOUT:
			Signalbus.display_batting_result.emit("STRIKEOUT!")
			strikeouts += 1
			strikeout.emit()
	Signalbus.display_points.emit(home_points, visitor_points)
	_toggle_special_buttons()
	_check_strikes()

# Process the result of pitching
func _process_pitching(left_die: Enums.DIE_TYPES, right_die: Enums.DIE_TYPES) -> void:
	var result = Dice._process_pitching(left_die, right_die, strikeDC[current_inning])
	match(result[1]):
		Enums.BATTING_RESULT.HOMERUN:
			Signalbus.display_batting_result.emit("HOME RUN!")
			visitor_points += _advance_base(4)
			advance_bases.emit(4)
		Enums.BATTING_RESULT.TRIPLE:
			Signalbus.display_batting_result.emit("TRIPLE!")
			visitor_points += _advance_base(3)
			advance_bases.emit(3)
		Enums.BATTING_RESULT.DOUBLE:
			Signalbus.display_batting_result.emit("DOUBLE!")
			visitor_points += _advance_base(2)
			advance_bases.emit(2)
		Enums.BATTING_RESULT.SINGLE:
			Signalbus.display_batting_result.emit("SINGLE!")
			visitor_points += _advance_base(1)
			advance_bases.emit(1)
		Enums.BATTING_RESULT.STRIKEOUT:
			Signalbus.display_batting_result.emit("STRIKEOUT!")
			strikeouts += 1
			strikeout.emit()
	Signalbus.display_points.emit(home_points, visitor_points)
	_toggle_special_buttons()
	_check_strikes()

# Advances the player(s) on the bases by the given amount
func _advance_base(amount: int) -> int:
	var points = 0
	for i in amount:
		# Third base, score 1 point
		if bases[2] == true:
			bases[2] = false
			points += 1
		# Second base, advance to third
		if bases[1]:
			bases[2] = true
			bases[1] = false
		# First base, advance to second
		if bases[0]:
			bases[1] = true
			bases[0] = false
		# (First iteration only), batter advances to first
		if i == 0:
			bases[0] = true
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
func _tag_out() -> int:
	# Tag out third base
	if bases[2]:
		bases[2] = false
	# Tag out second base
	elif bases[1]:
		bases[1] = false
	# Tag out first base
	else:
		bases[0] = false
	return 1

func _special_pressed() -> void:
	if current_inning % 2 == 0:
		visitor_points +=  _tag_out()
	else:
		home_points += _steal_base()

func _toggle_special_buttons() -> void:
	toggle_special.emit(!(bases[2] == true || bases[1] == true || bases[0] == true))

# Check strikeouts check 
func _check_strikes() -> void:
	if strikeouts >= 3:
		if current_inning >= 9:
			_game_over()
		else:
			Signalbus.display_batting_result.emit("CHANGE SIDES!")
			_next_inning()

# Reset all the bases
func _reset_bases() -> void:
	for base in bases:
		base = false

# (For testing) Set the players on specific bases
func _custom_bases(first: bool, second: bool, third: bool) -> void:
	bases[0] = first
	bases[1] = second
	bases[2] = third

# Advance to the next inning
func _next_inning() -> void:
	_reset_bases()
	strikeouts = 0
	current_inning += 1
	if current_inning > 9:
		current_inning = 1
	points_scored_this_inning = 0
	Signalbus.update_inning.emit(current_inning)

func _game_over() -> void:
	Signalbus.display_batting_result.emit("GAME OVER!")

func _connect_signals() -> void:
	Signalbus.roll_to_bat.connect(_process_batting)
	Signalbus.roll_to_pitch.connect(_process_pitching)
	Signalbus.special_pressed.connect(_special_pressed)
