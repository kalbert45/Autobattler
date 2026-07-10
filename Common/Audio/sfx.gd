class_name SFX
extends AudioStreamPlayer

var random = false
var rand_range = Vector2(0.8, 1.2)


func play_sfx():
	if random:
		pitch_scale = randf_range(rand_range.x, rand_range.y)
		
	play()
