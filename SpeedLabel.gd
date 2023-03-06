extends Label

var value = 0.0

func _on_player_speed_changed(s):
	value = s
	text = "Speed: %.3f" % value
