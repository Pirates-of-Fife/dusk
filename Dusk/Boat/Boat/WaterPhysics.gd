extends RigidBody3D

@export_category("Water Physics")
@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready
var water = get_parent_node_3d().get_parent_node_3d().get_node("WaterMover/Water")

@onready var probes = $BuyoancyProbes.get_children()

var footstep_sound = "res://Sound/Player/wood_foot_step.wav"

var submerged := false

var local_collision_pos : Vector3

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
		
	if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
		local_collision_pos = state.get_contact_local_position(0)
