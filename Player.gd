extends CharacterBody3D

signal rotation_changed(r)
signal speed_changed(s)

const deg_180 = 2 * PI

@export var max_speed = 10
@export var max_rotation = 0.1

@export var acceleration = 5
@export var braking = 15
@export var turning = 1
@export var speed = 0.0

var local_rotation = 0.0
var local_velocity = Vector3.ZERO

func accelerate(delta):
	speed = move_toward(speed, max_speed, acceleration * delta)
	
func brake(delta):
	speed = move_toward(speed, 0, braking * delta)

func turn(turn_axis, delta):
	var prev_rotation = local_rotation
	local_rotation = fmod(local_rotation + turn_axis * turning * delta, deg_180)
	local_rotation += 0 if local_rotation > 0 else deg_180
	return local_rotation - prev_rotation

#func turn_back(delta):
#	var prev_rotation = local_rotation
#	local_rotation = move_toward(prev_rotation, 0, turning * delta * 3)
#	return prev_rotation - local_rotation

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("vehicle_charge"):
		brake(delta)
	else:
		accelerate(delta)
		
	if speed != 0:
		direction.z = -1
		
	# turning
	var turn_axis = Input.get_axis("vehicle_turn_right", "vehicle_turn_left")
	var turn_offset = turn(turn_axis, delta) if turn_axis else 0
		
	emit_signal("speed_changed", speed)
	emit_signal("rotation_changed", local_rotation)

	# apply movement
	velocity = (direction * speed).rotated(Vector3.UP, local_rotation)
	move_and_slide()
	rotate_y(turn_offset)
