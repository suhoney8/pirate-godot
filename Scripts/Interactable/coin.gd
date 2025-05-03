extends Node2D

func _on_area_2d_area_entered(area):
	GameManager.gain_coins(1)
	queue_free()
