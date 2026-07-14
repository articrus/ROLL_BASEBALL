extends Node2D
@onready var pitchPlate = $Pitch
@onready var basePlates = {
	0: $First,
	1: $Second,
	2: $Third,
	3: $Home
}
@onready var outPos = $Out
@onready var spawnPos = $Spawn
@onready var scorePos = $Score
@onready var fieldPositions = [$FieldA, $FieldB]
@onready var ballScore = $BallScore ##Where the ball goes when it scores

func _get_base_position(plate: int) -> Vector2:
	return basePlates[plate].global_position

# For retrieving spawn/exit points
func _get_position(node) -> Vector2:
	return node.global_position

# For setting field batters
func _get_field_position(index: int) -> Vector2:
	return fieldPositions[index].global_position

# Get the position of the ball for animations
func _get_ball_position(didScore: bool) -> Vector2:
	if didScore:
		return _get_position(ballScore)
	else:
		return fieldPositions[randi_range(0, 1)].global_position

# Ease of access
func _get_pitch_position() -> Vector2: return _get_position(pitchPlate)
func _get_out_position() -> Vector2: return _get_position(outPos)
func _get_spawn_position() -> Vector2: return _get_position(spawnPos)
func _get_score_position() -> Vector2: return _get_position(scorePos)
