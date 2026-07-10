class_name SoundManager extends Node

const SFX_SCENE = preload("res://Common/Audio/sfx.tscn")

enum SOUND_NAMES {}

# enum -> preload
const NAME_TO_SOUND = {}
const NAME_TO_DB = {}
const NAME_TO_POLYPHONY = {}

var NAME_TO_SFX : Dictionary[SOUND_NAMES, SFX] = {}
var SFX_TIMERS : Dictionary[SOUND_NAMES, Timer] = {}
var SFX_COOLDOWNS : Dictionary[SOUND_NAMES, bool] = {}

func _ready() -> void:
	for sfx_name in SOUND_NAMES.values():
		var sfx = SFX_SCENE.instantiate()
		sfx.stream = NAME_TO_SOUND[sfx_name]
		add_child(sfx)
		NAME_TO_SFX[sfx_name] = sfx
		
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time= 0.02
		timer.connect("timeout", _on_sfx_timer_timeout.bind(sfx_name))
		add_child(timer)
		
		SFX_TIMERS[sfx_name] = timer
		SFX_COOLDOWNS[sfx_name] = false

func play_sfx(sound_name : SoundManager.SOUND_NAMES, _db = null, _random=null, _range=null) -> void:
	if SFX_COOLDOWNS[sound_name]: return
	var sfx = NAME_TO_SFX[sound_name]
	sfx.volume_db = NAME_TO_DB[sound_name]
	if NAME_TO_POLYPHONY.has(sound_name):
		sfx.max_polyphony = NAME_TO_POLYPHONY[sound_name]
	else:
		sfx.max_polyphony = 1
	if _db:
		sfx.volume_db = _db
	if _random:
		sfx.random = _random
	if _range:
		sfx.rand_range = _range
	sfx.play_sfx()
	
	SFX_COOLDOWNS[sound_name] = true
	SFX_TIMERS[sound_name].start()
	
func _on_sfx_timer_timeout(sfx_name : SOUND_NAMES) -> void:
	SFX_COOLDOWNS[sfx_name] = false
