extends AudioStreamPlayer3D

@export
var walking_footstep_delay : float = 0.4

@export
var running_footstep_delay : float = 0.2

var player : CharacterBody3D

var can_play_footstep_sound : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent_node_3d()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.is_running:
		$StepTimer.wait_time = running_footstep_delay
	else:
		$StepTimer.wait_time = walking_footstep_delay
	
	if player.velocity.length() > 0.3 and can_play_footstep_sound == true and player.is_on_floor() and player.target_velocity.length() > 0:
		pitch_scale = randf_range(0.6, 1)
		
		if (!playing):
			get_sound_file()
			play()
			can_play_footstep_sound = false
			$StepTimer.start()

func get_sound_file():
	var space_state = get_world_3d().direct_space_state
		
	var from = global_position
	var to = global_position - Vector3(0, 0.2, 0)
	
	var raycast = PhysicsRayQueryParameters3D.create(from, to, 1)
	
	var result = space_state.intersect_ray(raycast)
	
	if (result == null):
		stream = load("res://Sound/Player/concrete_foot_step.wav")
	
	if (result.has("collider")):
		if "footstep_sound" in result.collider:
			stream = load(result.collider.footstep_sound)
	else:
		stream = load("res://Sound/Player/concrete_foot_step.wav")

func _on_finished():
	stop() # Replace with function body.


func _on_step_timer_timeout():
	can_play_footstep_sound = true
