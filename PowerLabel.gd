extends Label

var value = 0

func _on_player_power_changed(p):
	value = p
	text = "Power: %d" % value
