extends CharacterBody3D

signal rotation_changed(r)
signal speed_changed(s)
signal charge_changed(c)

const deg_180 = 2 * PI

@export var max_speed = 50
@export var max_charge = 5
@export var max_rotation = 0.1

# factors
@export var accel_factor = 5
@export var braking_factor = 45
@export var turning_factor = 1
@export var discharge_factor = 5
@export var boost_factor = 2

# abilities
@export var power = 0

# state
@export var speed = 0.0
var charge = 0.0 
var local_rotation = 0.0
var local_velocity = Vector3.ZERO

func accelerate(delta):
	speed = move_toward(speed, max_speed, accel_factor * (charge * boost_factor + 1) * delta)
	charge = move_toward(charge, 0, discharge_factor * delta)
	
func build_charge(delta):
	speed = move_toward(speed, 0, braking_factor * delta)
	charge = move_toward(charge, max_charge, (power + 1) * delta)

func turn(turn_axis, delta):
	var prev_rotation = local_rotation
	local_rotation = fmod(local_rotation + turn_axis * turning_factor * delta, deg_180)
	local_rotation += 0 if local_rotation > 0 else deg_180
	return local_rotation - prev_rotation

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	build_charge(delta) if Input.is_action_pressed("vehicle_charge") else accelerate(delta)
		
	if speed != 0:
		direction.z = -1
		
	# turning
	var turn_axis = Input.get_axis("vehicle_turn_right", "vehicle_turn_left")
	var turn_offset = turn(turn_axis, delta) if turn_axis else 0
		
	emit_signal("speed_changed", speed)
	emit_signal("rotation_changed", local_rotation)
	emit_signal("charge_changed", charge)

	# apply movement
	velocity = (direction * speed).rotated(Vector3.UP, local_rotation)
	move_and_slide()
	rotate_y(turn_offset)
