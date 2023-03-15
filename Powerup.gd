extends CharacterBody3D

@export var spin_rate = 2

func _physics_process(delta):
	rotate_y(spin_rate * delta)

func initialize(position, rotation):
	self.position = position
	self.rotation_degrees = Vector3(0, rotation, 0)

func collect(player):
	if not is_queued_for_deletion():
		player.inc_power()
		queue_free()
