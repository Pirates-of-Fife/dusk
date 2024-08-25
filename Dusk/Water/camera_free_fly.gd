# Godot Sponza: Camera freelook and movement script
#
# Copyright © 2017-present Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Camera3D

const MOUSE_SENSITIVITY = 0.002

# The camera movement speed (tweakable using the mouse wheel).
var move_speed := 0.5

# Stores where the camera is wanting to go (based on pressed keys and speed modifier).
var motion := Vector3()

# Stores the effective camera velocity.
var velocity := Vector3()

# The initial camera node rotation.
var initial_rotation := rotation.y


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		motion.x = -1
	elif Input.is_action_pressed("move_backward"):
		motion.x = 1
	else:
		motion.x = 0

	if Input.is_action_pressed("move_left"):
		motion.z = 1
	elif Input.is_action_pressed("move_right"):
		motion.z = -1
	else:
		motion.z = 0

	if Input.is_action_pressed("move_up"):
		motion.y = 1
	elif Input.is_action_pressed("move_down"):
		motion.y = -1
	else:
		motion.y = 0

	# Normalize motion
	# (prevents diagonal movement from being `sqrt(2)` times faster than straight movement).
	motion = motion.normalized()

	# Speed modifier.
	if Input.is_action_pressed("move_speed"):
		motion *= 2

	# Rotate the motion based on the camera angle.
	motion = motion \
		.rotated(Vector3(0, 1, 0), rotation.y - initial_rotation) \
		.rotated(Vector3(1, 0, 0), cos(rotation.y) * rotation.x) \
		.rotated(Vector3(0, 0, 1), -sin(rotation.y) * rotation.x)

	# Add motion, apply friction and velocity.
	velocity += motion * move_speed
	velocity *= 0.9
	position += velocity * delta
