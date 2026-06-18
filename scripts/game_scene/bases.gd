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

func _get_base_position(plate: int) -> Vector2:
	return basePlates[plate].global_position

# For retrieving spawn/exit points
func _get_position(node) -> Vector2:
	return node.global_position

# Ease of access
func _get_pitch_position() -> Vector2: return _get_position(pitchPlate)
func _get_out_position() -> Vector2: return _get_position(outPos)
func _get_spawn_position() -> Vector2: return _get_position(spawnPos)
