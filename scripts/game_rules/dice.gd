extends Node
class_name Dice

# Rolls the dice and returns the number
static func _roll_die(sides: int) -> int:
	return randi_range(1, sides);

# Rolls a D6 and returns the resulting number and tier
static func _roll_d6() -> Array:
	var roll = _roll_die(6)
	var result = [roll, Enums.DICE_TIERS.UT]
	match(roll):
		6:
			result[1] = Enums.DICE_TIERS.HR
		5:
			result[1] = Enums.DICE_TIERS.TP
		4, 3:
			result[1] = Enums.DICE_TIERS.DB
		_: #1, 2, Failsafe
			result[1] = Enums.DICE_TIERS.UT
	return result

# Rolls a D8 and returns the resulting number and tier
static func _roll_d8() -> Array:
	var roll = _roll_die(8)
	var result = [roll, Enums.DICE_TIERS.UT]
	match(roll):
		8:
			result[1] = Enums.DICE_TIERS.HR
		7, 6:
			result[1] = Enums.DICE_TIERS.TP
		5, 4:
			result[1] = Enums.DICE_TIERS.DB
		_: # 3, 2, 1, Failsafe
			result[1] = Enums.DICE_TIERS.UT
	return result

# Rolls a D4 and returns the resulting number and tier
static func _roll_d4() -> Array:
	var roll = _roll_die(4)
	var result = [roll, Enums.DICE_TIERS.UT]
	match(roll):
		4:
			result[1] = Enums.DICE_TIERS.HR
		3:
			result[1] = Enums.DICE_TIERS.TP
		2:
			result[1] = Enums.DICE_TIERS.DB
		_: #1, Failsafe
			result[1] = Enums.DICE_TIERS.UT
	return result

# Returns the die result
static func _get_die_result(die: Enums.DIE_TYPES) -> Array:
	match(die):
		Enums.DIE_TYPES.CONTACT:
			return _roll_d8()
		Enums.DIE_TYPES.NORMAL:
			return _roll_d6()
		Enums.DIE_TYPES.POWER:
			return _roll_d4()
		_: # Failsafe
			return [0, Enums.DICE_TIERS.UT]

# Process the roll
static func _process_roll(dieA: Enums.DIE_TYPES, dieB: Enums.DIE_TYPES, strike: int, isBatting: bool) -> Array:
	var roll_A = _get_die_result(dieA)
	var roll_B = _get_die_result(dieB)
	Signalbus.update_die_faces.emit(dieA, roll_A[0], dieB, roll_B[0])
	var roll_total = roll_A[0] + roll_B[0]
	var result = [roll_total, Enums.BATTING_RESULT]
	# If roll results have a matching tier
	if(roll_A[1] == roll_B[1]):
		if !isBatting: 
			if roll_A[1] != Enums.DICE_TIERS.UT: # If pitching, any matching colors is an instant strikeout
				result[1] = Enums.BATTING_RESULT.STRIKEOUT
			else: # If not colored
				if(roll_total >= strike):
					result[1] = Enums.BATTING_RESULT.SINGLE # If > strike, single
				else:
					result[1] = Enums.BATTING_RESULT.DOUBLE # Else, double
		else:
			match(roll_A[1]):
				Enums.DICE_TIERS.HR:
					result[1] = Enums.BATTING_RESULT.HOMERUN
				Enums.DICE_TIERS.TP:
					result[1] = Enums.BATTING_RESULT.TRIPLE
				Enums.DICE_TIERS.DB:
					result[1] = Enums.BATTING_RESULT.DOUBLE
				# Untiered, needs to pass StrikeDC to get a single
				Enums.DICE_TIERS.UT:
					if(roll_total >= strike):
						result[1] = Enums.BATTING_RESULT.SINGLE
					else:
						result[1] = Enums.BATTING_RESULT.STRIKEOUT
	else: # Results to not have a matching tier/color
		if !isBatting: # If pitching, check against the strike 
			if(roll_total >= strike):
				result[1] = Enums.BATTING_RESULT.SINGLE # If > strike, single
			else:
				result[1] = Enums.BATTING_RESULT.DOUBLE # Else, double
		else: # If batting, check against the strike 
			if(roll_total >= strike):
				result[1] = Enums.BATTING_RESULT.SINGLE
			else:
				result[1] = Enums.BATTING_RESULT.STRIKEOUT
	return result

# Process the rolling of the special
static func _process_special() -> int:
	var roll_A = _roll_d6()
	var roll_B = _roll_d6()
	Signalbus.update_die_faces.emit(Enums.DIE_TYPES.NORMAL, roll_A[0], Enums.DIE_TYPES.NORMAL, roll_B[0])
	return roll_A[0] + roll_B[0]
