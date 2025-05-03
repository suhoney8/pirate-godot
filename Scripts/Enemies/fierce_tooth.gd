extends CharacterBody2D


var speed = -60.0
var facing_right = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$AnimationPlayer.play("tooth_run")
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if !$RayCast2D.is_colliding() and is_on_floor():
		flip()
	
	velocity.x = speed
	move_and_slide()
	
func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1	

func _on_hitbox_area_entered(area):
	if area.get_parent() is Captain:
		area.get_parent().captain_die()
