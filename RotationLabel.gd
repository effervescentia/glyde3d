extends Label

var value = 0.0


func _on_player_rotation_changed(r):
	value = r
	text = "Rotation: %.3f" % value
