extends Label
# Export Vars
@export var max_time: float = 3.0
@export var typing_speed : float = 60
# Other Vars
var typing_time : float
var time_elapsed: float

func _set_text(result: String) -> void:
	time_elapsed = 0
	self.text = result
	self.visible_characters = 0
	typing_time = 0
	while self.visible_characters < self.get_total_character_count():
		typing_time += get_process_delta_time()
		self.visible_characters = typing_speed * typing_time as int
		await get_tree().process_frame

func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= max_time:
		time_elapsed = 0
		self.visible = false
