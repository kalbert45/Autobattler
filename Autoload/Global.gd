extends Node

const SOUND_MANAGER_SCENE = preload("res://Common/Audio/sound_manager.tscn")


enum DEBUG_FLAGS {
}

@export_flags("SHOW_TIMER") var debug := 0

var CONTROLLER := false

var sound_manager : SoundManager

func _ready() -> void:
	check_control_scheme()
	
	sound_manager = SOUND_MANAGER_SCENE.instantiate()
	add_child(sound_manager)

func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventKey:
		CONTROLLER = false
	elif event is InputEventJoypadButton:
		CONTROLLER = true

func check_control_scheme() -> void:
	if Input.get_connected_joypads().size() > 0:
		CONTROLLER = true
	else:
		CONTROLLER = false


# General sfx player
func play_sfx(sound_name : SoundManager.SOUND_NAMES, _db = null, _random=null, _range=null) -> void:
	sound_manager.play_sfx(sound_name, _db, _random, _range)
