extends Node


@export var powerup_scene: PackedScene


func _ready():
	randomize()
	
	for n in range(10):
		add_powerup()


func add_powerup():
	var powerup = powerup_scene.instantiate()
	
	var rng = RandomNumberGenerator.new()
	var rnd_x = rng.randi_range(-25, 25)
	var rnd_z = rng.randi_range(-25, 25)
	var rnd_r = rng.randf_range(0, 360)

	powerup.initialize(Vector3(rnd_x, 0.7, rnd_z), rnd_r)
	
	add_child(powerup)
