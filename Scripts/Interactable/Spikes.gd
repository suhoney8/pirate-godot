extends Node2D

func _ready():
	var animation_spikes = $AnimationPlayer
	animation_spikes.play("Activated")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Captain:
		area.get_parent().captain_die()
		

func _on_area_2d_body_entered(body):
	if "Captain" in body.name:
		body.take_damage(30)
