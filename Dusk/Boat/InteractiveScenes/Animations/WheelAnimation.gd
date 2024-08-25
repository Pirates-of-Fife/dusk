extends Node3D

@export
var wheel_rotation : float = 0

var last_wheel_rotation : float = 0

var wheel_delta : float

@onready
var audio : AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready
var animation : AnimationPlayer = $AnimationPlayer

var can_play_wheel_audio : bool

func _process(delta):
	var wheel = $SteeringWheel
	
	wheel_delta = last_wheel_rotation - wheel_rotation
	
	wheel.rotation.y = deg_to_rad(wheel_rotation * -300.0)
	
	last_wheel_rotation = wheel_rotation
	
	if (abs(wheel_delta) > 0.01):
		start_wheel_audio()
	else:
		stop_wheel_audio()


func start_wheel_audio():
	if (can_play_wheel_audio):
		audio.pitch_scale = randf_range(0.9, 1.1)
		animation.play("wheel_turn_audio_start")
		audio.play()
		can_play_wheel_audio = false

func stop_wheel_audio():
	animation.play("wheel_turn_audio_stop")
	can_play_wheel_audio = true


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "wheel_turn_audio_stop"):
		audio.stop()
	
