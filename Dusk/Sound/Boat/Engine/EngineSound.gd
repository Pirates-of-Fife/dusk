extends Node3D

@onready
var main_sound := $AudioStreamPlayer3D

@onready
var secondary_sound := $AudioStreamPlayer3D2

@export
var animation_controller : Node3D

@export
var pitch_scale_curve : Curve

@export
var secondary_audio_pitch_scale_curve : Curve

func _process(delta):
	if (animation_controller.rpm == 0):
		main_sound.stop()
		secondary_sound.stop()
	elif (animation_controller.rpm > 0 and main_sound.playing == false):
		main_sound.play()
		secondary_sound.play()
	
	main_sound.pitch_scale = pitch_scale_curve.sample(normalize_engine_rpm(animation_controller.rpm))
	secondary_sound.pitch_scale = secondary_audio_pitch_scale_curve.sample(normalize_engine_rpm(animation_controller.rpm))
	#print("RPM:" + str(animation_controller.rpm) + " Norm: " + str(normalize_engine_rpm(animation_controller.rpm)) + " Pitch: " + str(main_sound.pitch_scale))
	


func normalize_engine_rpm(rpm : float) -> float:
	return (rpm / 10000);
