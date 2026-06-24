extends Control
@onready var left_box = $TextureRect/LeftStrategy
@onready var right_box = $TextureRect/RightStrategy
@onready var roll_box = $RollBox
@onready var specialButton = $StealTagButton
@onready var die_table = $DiceTable
# Temporary Nodes
@onready var result = $DebugDisplay/BattingResult
@onready var inning = $DebugDisplay/Inning
@onready var player_points = $DebugDisplay/PlayerPoints
@onready var com_points = $DebugDisplay/VisitorPoints
# Export vars
@export var left_die_type: Enums.DIE_TYPES = Enums.DIE_TYPES.NORMAL
@export var right_die_type: Enums.DIE_TYPES = Enums.DIE_TYPES.NORMAL

func _ready() -> void:
	_bind_die_tabs()
	_connect_signals()
	_disable_special(true)

func _roll_dice() -> void:
	Signalbus.process_roll.emit(left_die_type, right_die_type)

func _change_left_die(die: Enums.DIE_TYPES) -> void:
	left_die_type = die
	roll_box._change_rolling_dice(left_die_type, right_die_type)

func _change_right_die(die: Enums.DIE_TYPES) -> void:
	right_die_type = die
	roll_box._change_rolling_dice(left_die_type, right_die_type)

func _change_sides(isPlayer: bool) -> void:
	roll_box._update_inning(isPlayer)

# Might be temporary, used to bind die types
func _bind_die_tabs() -> void:
	# Left Box
	left_box.powerBtn.pressed.connect(_change_left_die.bind(Enums.DIE_TYPES.POWER))
	left_box.normalBtn.pressed.connect(_change_left_die.bind(Enums.DIE_TYPES.NORMAL))
	left_box.contactBtn.pressed.connect(_change_left_die.bind(Enums.DIE_TYPES.CONTACT))
	# Right Box
	right_box.powerBtn.pressed.connect(_change_right_die.bind(Enums.DIE_TYPES.POWER))
	right_box.normalBtn.pressed.connect(_change_right_die.bind(Enums.DIE_TYPES.NORMAL))
	right_box.contactBtn.pressed.connect(_change_right_die.bind(Enums.DIE_TYPES.CONTACT))

func _show_result(toPrint: String) -> void:
	result.text = "RESULT: " + toPrint

func _update_points(player: int, com: int) -> void:
	player_points.text = "PLAYER: " + str(player)
	com_points.text = "COM: " + str(com)

func _update_inning(newInning: int) -> void:
	inning.text = "INNING: " + str(newInning)
	if newInning % 2 == 0:
		_change_sides(false)
		_special_button(false)
		_disable_special(true)
	else:
		_change_sides(true)
		_special_button(true)
		_disable_special(true)

func _special_button(isBatting: bool) -> void:
	if isBatting:
		specialButton.text = "STEAL"
	else:
		specialButton.text = "TAG OUT"

func _disable_special(toggle: bool) -> void:
	specialButton.disabled = toggle

func _on_steal_tag_button_pressed() -> void:
	Signalbus.special_pressed.emit()

func _connect_signals() -> void:
	Signalbus.roll_button_pressed.connect(_roll_dice)
	# Temporary display results
	Signalbus.display_batting_result.connect(_show_result)
	Signalbus.display_points.connect(_update_points)
	Signalbus.update_inning.connect(_update_inning)

func _on_die_table_buton_pressed() -> void:
	die_table.visible = true
