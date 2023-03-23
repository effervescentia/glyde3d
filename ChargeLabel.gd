extends Label

var value = 0.0


func _on_player_charge_changed(c):
	value = c
	text = "Charge: %.3f" % value
