extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/Main/Water')

@onready var probes = $ProbeContainer.get_children()

var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var forward_force = 1500
	var rotation_speed = 40
	
	var force = Vector3()
	var torque = Vector3()

	# Forward and backward movement
	if Input.is_key_pressed(KEY_W):
		force += transform.basis.z * -forward_force
	elif Input.is_key_pressed(KEY_S):
		force += transform.basis.z * forward_force

	# Applying the force for movement
	apply_central_force(force)

	# Rotation
	if Input.is_key_pressed(KEY_D):
		torque += Vector3(0, -rotation_speed, 0)
	elif Input.is_key_pressed(KEY_A):
		torque += Vector3(0, rotation_speed, 0)

	# Applying the torque for rotation
	apply_torque_impulse(torque)

func _physics_process(delta):
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
