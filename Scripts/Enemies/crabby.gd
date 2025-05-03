extends CharacterBody2D
class_name Crabby

var speed = -40.0
var facing_right = true

# When turned true it does chase our player
# However, randomization doesn't works after the player exits the screen
var is_crabby_chase: bool = false

var health = 80
var health_max = 80
var health_min = 0

var crabby_dead: bool = false
var crabby_taking_damage: bool = false
var crabby_damage_to_deal = 20
var crabby_is_dealing_damage: bool = false

var crabby_direction: Vector2
var crabby_is_roaming: bool = true

const gravity = 900
var knockback_force = 200

var player: CharacterBody2D
var player_in_area = false

func _ready():
	crabby_animation_handler()
	$DirectionTimer.start()
	
func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	
	if !$RayCast2D.is_colliding() and is_on_floor():
		flip()
		
	velocity.x = speed
	
	player = GameManager.captain
	
	move(delta)
	move_and_slide()
	
func move(delta):
	if !crabby_dead:
		if not is_crabby_chase:
			velocity += crabby_direction * speed * delta
			
		elif is_crabby_chase and not crabby_taking_damage:
			var direction_to_player = position.direction_to(player.position) * speed
			velocity.x = direction_to_player.x
			crabby_direction.x = abs(velocity.x) / velocity.x
			
		crabby_is_roaming = true
		
	elif crabby_dead:
		velocity.x = 0
		
func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	
	if facing_right:
		speed = abs(speed) * -1
	else:
		speed = abs(speed) 
		
func _on_direction_timer_timeout():
	$DirectionTimer.wait_time = choose([1.0, 1.5, 2.0, 2.5])
	if not is_crabby_chase:
		crabby_direction = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
		flip()
		
func choose(array):
	array.shuffle()
	return array.front()
	
func crabby_animation_handler():
	var crabby_animation = $AnimationPlayer
	if not crabby_dead and not crabby_taking_damage and not crabby_is_dealing_damage:
		crabby_animation.play("crabby_run")
		
	elif not crabby_dead and crabby_taking_damage and not crabby_is_dealing_damage:
		crabby_animation.play("crabby_hit_hurt")
		crabby_taking_damage = false
	
	elif crabby_dead and crabby_is_roaming:
		crabby_is_roaming = false
		crabby_animation.play("crabby_death_ground")
		handle_crabby_death()

func handle_crabby_death():
	self.queue_free()
