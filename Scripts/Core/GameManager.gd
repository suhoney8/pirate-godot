extends Node

signal gained_coins(int)

var coins : int
var current_checkpoint : Checkpoints
var captain: Captain

func respawn_captain():
	if current_checkpoint != null:
		captain.position = current_checkpoint.global_position

func gain_coins(coins_gained : int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	
