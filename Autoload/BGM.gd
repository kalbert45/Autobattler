extends AudioStreamPlayer

var new_bgm_path : String

var bgm_db = 0.0
var ambience_db = -4.0

var _tween : Tween

var loop_timer : Timer
var loop_gap = 60 # number of seconds between each loop.
var loop := true

func _ready() -> void:
	loop_timer = Timer.new()
	loop_timer.one_shot = true
	loop_timer.timeout.connect(_on_loop_timer_timeout)
	add_child(loop_timer)
	if stream:
		loop_timer.start(10.0)

func set_bgm(path, db = 0.0):
	if playing:
		new_bgm_path = path
	else:
		bgm_db = db
		var s = load('res://Assets/Sounds/BGM/' + path)
		stream = s

func set_bgm_null():
	var s = null
	stream = s

# basic function. play bgm.
func play_bgm():
	if not new_bgm_path.is_empty():
		var s = load('res://Assets/Sounds/BGM/' + new_bgm_path)
		stream = s
		new_bgm_path = ""
	
	volume_db = bgm_db
	play()

func stop_loop():
	loop = false
	loop_timer.stop()
	fade_bgm_to_ambience(1.0, -20.0)
	
func start_loop():
	if not loop_timer.is_stopped(): return
	loop = true
	loop_timer.start(30.0)

# hard cut ambience
func set_ambience(path, db):
	ambience_db = db
	var s = load('res://Assets/Sounds/Ambience/' + path)
	$Ambience.stream = s

func set_ambience_null():
	var s = null
	$Ambience.stream = s

func play_ambience():
	if _tween and _tween.is_running():
		_tween.kill()
		_tween.emit_signal("finished")
	
	$Ambience.volume_db = ambience_db
	$Ambience.play()

# fades ambience, then plays bgm.
# fades back after bgm is finished.
# 0: fade out length. 1: pause until bgm begins
func fade_ambience_to_bgm(fade_time, target_db = -6.0, pause_time=0.5):
	if _tween and _tween.is_running():
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property($Ambience, "volume_db", target_db, fade_time)\
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
			
	await _tween.finished
	await get_tree().create_timer(pause_time).timeout
	
	play_bgm()

# crossfade, different from ambience to bgm.
func fade_bgm_to_ambience(fade_time, target_db = -40.0, pause_time=0.5):
	if _tween and _tween.is_running():
		_tween.kill()
	
	_tween = get_tree().create_tween().set_parallel(true)
	_tween.tween_property(self, "volume_db", target_db, fade_time)\
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	_tween.tween_property($Ambience, "volume_db", ambience_db, fade_time)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_delay(pause_time)
			
	await _tween.finished
	
	stop()
	
func _on_loop_timer_timeout():
	if not loop: return
	fade_ambience_to_bgm(1.0, -6.0)

func _on_finished() -> void:
	fade_bgm_to_ambience(1.0, -20.0)
	if loop:
		loop_timer.start(loop_gap)
