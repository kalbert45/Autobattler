class_name CooldownTimer
extends Timer

var cooldown : float # true default wait time
var _carry_over : float = 0.0

func clear_carry_over() -> void:
	_carry_over = 0.0

# resets wait time to cooldown each time. 
func start_timer(time = cooldown, refresh : bool = true) -> void:
	#_timeout_lock = false
	if refresh: start(time)
	else: start(time - _carry_over)
	_carry_over = 0.0

func subtract_cooldown(x : float):
	if x >= time_left:
		_carry_over = x - time_left
		stop()
		emit_signal("timeout")
	else:
		# wait for timeout to go through in edge case
		#await get_tree().process_frame
		start_timer(time_left - x)
	
func add_cooldown(x : float):
	await get_tree().process_frame
	start_timer(time_left + x)
	
