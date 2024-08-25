extends Node3D

@onready
var animation_controller = $AnimationController

@onready
var boat_rigidbody = $ShipHull

@onready
var throttle_dead_zone_timer : Timer = $Timers/ThrottleDeadzoneTimer

@onready
var player_spawn_location = $ShipHull/PlayerSpawn

@onready
var player_ladder_location = $ShipHull/PlayerLadderSpawn

@export_category("Engine Parameters")

@export_range(0, 10000)
var max_engine_rpm : float = 6000

@export
var idle_rpm : float = 1000

@export
var max_engine_force : float = 3000

@export
var max_turning_force : float = 250

@export
var engine_force : Curve

@export_category("Throttle Parameters")

var throttle : float = 0

@export
var throttle_sensitivity : float = 0.5

@export
var throttle_deadzone : float = 0.1

var engine_rpm : float
var wheel_turn : float = 0

var engine_on : bool = false
var engine_off : bool = true
var clutch_active : bool

@onready
var player : Node3D = get_parent_node_3d().get_node("Player")
var is_player_seated : bool = false

@onready
var map = $ShipHull/Map

var fuel = 1

var _closest_distance : float = 5000

var map_active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShipHull/Mesh/Interior/RPM_Gauge.max_value = max_engine_rpm

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var throttle_input : float = 0
	
	if (is_player_seated):
		throttle_input = Input.get_axis("throttle_backwards", "throttle_forwards");
	
	throttle += throttle_input * delta * throttle_sensitivity
	throttle = clampf(throttle, -1, 1)
	
	# Throttle Deadzone
	# When throttle value is in the deadzone, timer starts and sets throttle to zero after finishing
	if ((throttle <= throttle_deadzone and throttle >= -throttle_deadzone) and throttle != 0):
		if (throttle_dead_zone_timer.is_stopped()):
			throttle_dead_zone_timer.start()
			
	if (throttle == 0):
		clutch_active = true
	else:
		clutch_active = false
	
	if (engine_on == true and engine_off == false):
		engine_rpm = lerpf(engine_rpm, calculate_rpm_from_throttle(throttle), delta / 4)
		
	var turn_input : float = 0
	
	if (is_player_seated):
		turn_input = Input.get_axis("turn_left", "turn_right")
	
	wheel_turn = lerpf(wheel_turn, turn_input, delta * 2)
	
	if (Input.is_action_just_released("open_map") and is_player_seated):
		if (map.unlocked_parts > 0):
			if (map_active):
				map.show()
				$ShipHull/Map2.hide()
				$ShipHull/Map2/MapSound.play()
				map_active = false
			else:
				map.hide()
				$ShipHull/Map2.show()
				$ShipHull/Map2/MapSound2.play()
				map_active = true
	
	update_animations()

func _physics_process(delta):
	if (clutch_active == false):
		var engine_rpm_normalized = engine_rpm / max_engine_rpm
		
		var force = max_engine_force * engine_force.sample(engine_rpm_normalized)
		
		if (throttle > 0):
			boat_rigidbody.apply_central_force(-boat_rigidbody.transform.basis.x * force)
		else:
			boat_rigidbody.apply_central_force(boat_rigidbody.transform.basis.x * force)
	
	var turn_reverse_multiplier = 1
	
	if (throttle < 0):
		turn_reverse_multiplier = -1
		
	boat_rigidbody.apply_torque_impulse(boat_rigidbody.transform.basis.y * -wheel_turn * max_turning_force * boat_rigidbody.linear_velocity.length() * turn_reverse_multiplier)
	
	boat_rigidbody.rotation_degrees.x = lerpf(boat_rigidbody.rotation_degrees.x, wheel_turn * 8000 * 0.0003 * boat_rigidbody.linear_velocity.length(), delta / 2)

func update_animations() -> void:
	adjust_fuel()
	animation_controller.throttle = throttle
	animation_controller.rpm = engine_rpm
	animation_controller.wheel_turn = wheel_turn
	animation_controller.speed = boat_rigidbody.linear_velocity.length()
	animation_controller.fuel = fuel
	
	var compass_heading = -((-boat_rigidbody.rotation_degrees.y) - 90)

	if (compass_heading < 0):
		compass_heading = 360.0 + compass_heading
	
	animation_controller.heading = compass_heading
	
	animation_controller.clutch_on = clutch_active

func calculate_rpm_from_throttle(throttle : float) -> float:
	return lerpf(idle_rpm, max_engine_rpm, abs(throttle))

func start_engine() -> void:
	var start_engine_thread : Thread = Thread.new()
	engine_on = true
	start_engine_thread.start(start_engine_animation_thread)
	$ShipHull/Mesh/cabin/radar.radar_on = true

func start_engine_animation_thread() -> void:
	while engine_rpm < idle_rpm - 50.0:
		engine_rpm = lerpf(engine_rpm, idle_rpm, get_process_delta_time())
		await get_tree().create_timer(0.02).timeout
	
	engine_rpm = idle_rpm
	engine_off = false

func stop_engine() -> void:
	var stop_engine_thread : Thread = Thread.new()
	engine_on = false
	stop_engine_thread.start(stop_engine_animation_thread)
	$ShipHull/Mesh/cabin/radar.radar_on = false

func stop_engine_animation_thread() -> void:
	while engine_rpm > 100:
		engine_rpm = lerpf(engine_rpm, 0, get_process_delta_time())
		await get_tree().create_timer(0.02).timeout
	
	engine_rpm = 0
	engine_off = true

func _on_throttle_deadzone_timer_timeout():
	if (throttle <= throttle_deadzone and throttle >= -throttle_deadzone):
		throttle = 0

func enter_boat():
	$ShipHull/Camera/TwistPivot/PitchPivot/BoatCamera.current = true
	$ShipHull/Mesh/Interior/seats/Interactable.active = false
	$ShipHull/Mesh/Interior/seats/InteractableWhileSitting.active = true
	player.enter_boat()
	is_player_seated = true
	$InteractableSystem.disabled = false
	$ShipHull/RainParticles.emitting = true
	player.get_node("RainParticles").emitting = false
	
	$ShipHull/Camera/TwistPivot.rotation = Vector3.ZERO
	$ShipHull/Camera/TwistPivot/PitchPivot.rotation = Vector3.ZERO
	$ShipHull/MeshInstance3D/SpotLight3D.show()
	
	if (!$ShipHull/Mesh/Interior/lamp.visible):
		$ShipHull/Mesh/Interior/lamp.show()
		$ShipHull/Mesh/Interior/lamp_off.hide()
	
	map.show()

func exit_boat():
	$ShipHull/MeshInstance3D/SpotLight3D.hide()
	player.global_position = $ShipHull/PlayerSpawn.global_position
	
	$ShipHull/Camera/TwistPivot/PitchPivot/BoatCamera.current = false
	$ShipHull/Mesh/Interior/seats/Interactable.active = true
	$ShipHull/Mesh/Interior/seats/InteractableWhileSitting.active = false
	player.exit_boat()
	is_player_seated = false
	$InteractableSystem.disabled = true
	$ShipHull/RainParticles.emitting = false
	player.get_node("RainParticles").emitting = true
	
	$ShipHull/Map2.hide()
	
	map_active = false
	
	map.hide()

func _on_start_stop_button_button_press():
	if (engine_off == true):
		start_engine()
		
	if (engine_off == false and engine_on == true):
		stop_engine()


func _on_interactable_enter_ship_interact():
	enter_boat()


func _on_interactable_exit_ship_interact():
	exit_boat()


func _on_ladder_player_used_ladder():
	player.global_position = player_ladder_location.global_position
	var twist_pivot : Node3D = player.get_node("Head/TwistPivot")
	var pitch_pivot : Node3D = player.get_node("Head/TwistPivot/PitchPivot")
	twist_pivot.rotation.y = $ShipHull/Mesh/Hull/ladder/Ladder.rotation.y
	pitch_pivot.rotation.x = 0

func _on_cabin_area_body_entered(body):
	var ambiant = get_parent_node_3d().get_node("AmbientSound")
	ambiant.set_muffled(true)
	
	$ShipHull/HullSounds.set_muffled(true)
	
	await get_tree().create_timer(0.5).timeout
	
	if (!$ShipHull/Mesh/Interior/lamp.visible):
		$ShipHull/Mesh/Interior/lamp.show()
		$ShipHull/Mesh/Interior/lamp_off.hide()


func _on_cabin_area_body_exited(body):
	var ambiant = get_parent_node_3d().get_node("AmbientSound")
	
	if (!is_player_seated):
		ambiant.set_muffled(false)
		$ShipHull/HullSounds.set_muffled(false)
	
	await get_tree().create_timer(10).timeout
	
	if ($ShipHull/Mesh/Interior/lamp.visible and !is_player_seated):
		$ShipHull/Mesh/Interior/lamp.hide()
		$ShipHull/Mesh/Interior/lamp_off.show()


func _on_ship_hull_body_entered(body):
	if (body != player):
		$ShipHull/HullSounds.collision($ShipHull.local_collision_pos, $ShipHull.linear_velocity.length())


func leviathan_collision():
	$ShipHull/HullSounds.collision($ShipHull/Mesh/Hull/Hull/RightEngine.global_position, 50)
	
	$ShipHull.apply_torque_impulse(Vector3(10000, 500000, 12400))
	
	max_engine_force = 670000
	$ShipHull/Fire.amount_ratio = 1
	$ShipHull/Fire/AudioStreamPlayer3D.play()
	$ShipHull/Fire/OmniLight3D.show()
	
func leviathan_sink():
	$ShipHull/HullSounds.collision($ShipHull/Mesh/Hull/Hull/RightEngine.global_position, 50)
	
	$ShipHull.apply_torque_impulse(Vector3(100000, 500000, 124000))
	
	$ShipHull.float_force = 600


func adjust_fuel():
	var island_3 : Node3D = get_parent_node_3d().get_node("Island3Terrain")
	
	if (island_3 == null):
		return

	var distance : float = ($ShipHull.global_position - island_3.global_position).length()
	
	if (distance > _closest_distance):
		return
	
	if (distance < _closest_distance):
		_closest_distance = distance
		
		var distance_normalized : float = distance / 2300 
		
		fuel = lerpf(0, 100, distance_normalized)
		
