class_name Unit extends Control

enum SIDE_FLAGS {
	PLAYER = 1 << 0,
	ENEMY = 1 << 1
}

const MAX_LEVEL = 3
const EXP_THRESHOLDS = [2, 3]

var _tween : Tween
@export var _board : Board

@export var SIDE := SIDE_FLAGS.PLAYER

# ALL 'permanent' changes go into data resource
@export var data : UnitData

var current_health := 100 :
	set(value):
		current_health = clamp(value, 0, data.max_health)
		%Health.text = str(current_health)
		if current_health <= 0:
			death()
var level := 1 :
	set(value):
		level = value
		%Lvl.text = "Lvl" + str(level)
		if level == MAX_LEVEL:
			%EXPProgress.visible = false
		data.level = level
var experience := 0 :
	set(value):
		experience = value
		data.experience = experience
		

var in_shop := false
var selected := false :
	set(value):
		selected = value
		sprite.material.set_shader_parameter("thickness", 1.0 if selected else 0.0)

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var cd_timer : CooldownTimer = $CDTimer
@onready var cd_progress = %CDProgress
@onready var mouse_box = $MouseBox

func _ready() -> void:
	SignalBus.battle_start.connect(_on_battle_start)
	SignalBus.battle_end.connect(_on_battle_end)
	
	cd_timer.cooldown = data.ability_cd
	sprite.flip_h = (SIDE == SIDE_FLAGS.ENEMY)
	self.level = data.level
	self.experience = data.experience
	self.current_health = data.max_health

func _on_cd_timer_timeout() -> void:
	use_ability()

func _on_battle_start() -> void:
	cd_timer.start_timer()

func _on_battle_end(_win : bool) -> void:
	cd_timer.stop()

func _process(_delta: float) -> void:
	cd_progress.value = (cd_timer.time_left / cd_timer.cooldown) * 100.0

#---------------------------------------
func combine_with(unit : Unit) -> void:
	if self == unit : return
	self.experience += unit.level
	_board.remove_unit(unit)
	unit.queue_free()
#---------------------------------
func take_damage(dmg : DamageSource) -> void:
	if SIDE & dmg.affected_side_flags:
		self.current_health -= dmg.amount
	
func death() -> void:
	_board.remove_unit(self)
	queue_free()

# define locally
#-------------------------------
# DEFAULT ABILITY :
# move 1 space laterally, and hit all units in the row
func use_ability() -> void:
	var available_coords = _board.get_coords_in_range(self, [Vector2i(0, 1), Vector2i(0, -1)])
	available_coords = available_coords.filter((func (x : Vector2i) : return _board.is_coord_available(x)))
	if not available_coords.is_empty():
		var target_coord = available_coords.pick_random()
		await _board.move_unit(self, target_coord)
	
	var target_coords = _board.get_coords_in_range(self, [
		Vector2i(1,0),
		Vector2i(2,0),
		Vector2i(3,0),
		Vector2i(4,0),
		Vector2i(5,0),
		Vector2i(6,0),
		Vector2i(7,0),
		], (SIDE & SIDE_FLAGS.ENEMY == SIDE))
		
	var dmg = DamageSource.new()
	dmg.amount = 20
	dmg.affected_side_flags = SIDE_FLAGS.PLAYER | SIDE_FLAGS.ENEMY
	_board.damage_all_coords(dmg, target_coords)

# visuals
#-------------------------------
func toggle_tooltip(on : bool) -> void:
	set_tooltip()
	%Tooltip.visible = on

func set_tooltip() -> void:
	pass

func move_to(p : Vector2) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
		
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "global_position", p, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	await _tween.finished

#------------------------------

func _on_mouse_entered() -> void:
	SignalBus.unit_hovered.emit(self, true)

func _on_mouse_exited() -> void:
	SignalBus.unit_hovered.emit(self, false)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") or event.is_action_pressed("Controller_A"):
		SignalBus.unit_selected.emit(self)

# helper functions (ex. target nearest enemy)
#------------------------------
