extends Sprite2D
@export var pitchTime:= 0.25
@export var scoreTime:= 0.5

# Pitches the ball, then sets the end position
func _pitch_ball(homePlate: Vector2, endPos: Vector2) -> void:
	var rotTween = create_tween()
	rotTween.tween_property(self, "rotation_degrees", 360 * 5, pitchTime + scoreTime)
	var pitchTween = create_tween()
	pitchTween.tween_property(self, "global_position", homePlate, pitchTime)
	await pitchTween.finished
	var endTween = create_tween()
	endTween.tween_property(self, "global_position", endPos, scoreTime)
	await endTween.finished
	self.queue_free()
