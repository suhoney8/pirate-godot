extends CharacterBody2D
class_name Captain

@onready var animation_player = $AnimationPlayer
@onready var sprite_player = $Sprite2D
@onready var deal_damage_zone = $AttackArea

@export var speed = 75.0
@export var max_run_speed: float = 135.0
@export var max_sprint_speed: float = 180.0

@export var jump_velocity = -500.0
@export var base_jump_speed: float = 300.0
@export var jump_speed_increase: float = 9.375
# The jump count
var jump_count = 0
var max_jumps = 1

@export var run_accel: float = 337.5
@export var run_decel: float = 1125.0

@onready var healthbar = $HealthBar

@export var death_position = Vector2(244, 1398)

@export var captain_attacking = false
var attack_type: String
var current_attack: bool

var health = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.captain = self
	current_attack = false
	healthbar.init_health(health)
	
# func _process(delta):
	
func _physics_process(delta):
	if Input.is_action_pressed("player_left"):
		sprite_player.scale.x = abs(sprite_player.scale.x) * -1
		deal_damage_zone.scale.x = abs(deal_damage_zone.scale.x) * -1
	if Input.is_action_pressed("player_right"):
		sprite_player.scale.x = abs(sprite_player.scale.x)
		deal_damage_zone.scale.x = abs(deal_damage_zone.scale.x)
	
	apply_gravity(delta)
	handle_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_left", "player_right")
	handle_acceleration(direction, delta)
	apply_friction(direction, delta)
	
	handle_attack_input()
	update_animation()
	move_and_slide()
	
	if position.y >= 1635:
		position = death_position
		captain_die()
		
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func handle_acceleration(direction, delta):
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, run_accel )
		
func apply_friction(direction, delta):
	if direction == 0:
		velocity.x = move_toward(velocity.x, direction * speed, run_decel )
		
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("player_jump"):
			velocity.y = jump_velocity
			jump_count = 0
			
	else:
		if Input.is_action_just_pressed("player_jump") and jump_count < max_jumps:
			velocity.y = jump_velocity
			jump_count += 1
	
	if velocity.y < jump_velocity / 2:
		velocity.y = jump_velocity / 2
		
func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	for area in overlapping_objects:
		var parent = area.get_parent()
		print(parent.name)
		parent.queue_free()
		# parent.set_damage()
				
	captain_attacking = true
	
func handle_attack_input():
	if Input.is_action_just_pressed("attack_1") or Input.is_action_just_pressed("attack_2") or Input.is_action_just_pressed("attack_3"):
		if is_on_floor():
			current_attack = true
			if Input.is_action_just_pressed("attack_1") and is_on_floor():
				attack_type = "attack_1"
				attack()
			elif Input.is_action_just_pressed("attack_2") and is_on_floor():
				attack_type = "attack_2"
				attack()
			elif Input.is_action_just_pressed("attack_3") and is_on_floor():
				attack_type = "attack_3"
				attack()
			handle_attack_animation(attack_type)
			set_damage(attack_type)
		
func update_animation():
	if !current_attack:
		if velocity.x != 0:
			animation_player.play("run_sword")
		else:
			animation_player.play("idle_sword")
		
		if velocity.y < 0:
			animation_player.play("jump_sword")
		if velocity.y > 0:
			animation_player.play("fall_sword")
			
func handle_attack_animation(attack_type):
	if current_attack:
		var attack_animation = str(attack_type)
		animation_player.play(attack_animation)
		
func set_damage(attack_type):
	var current_damage_to_deal: int
	if attack_type == "attack_1":
		current_damage_to_deal = 8
	if attack_type == "attack_2":
		current_damage_to_deal = 16
	if attack_type == "attack_3":
		current_damage_to_deal = 20
	
func _on_animation_player_animation_finished(attack_type):
	current_attack = false
	
func captain_die():
	GameManager.respawn_captain()

func _set_health(value):
	health = value
	if health <= 0:
		captain_die()
		
	healthbar.health = health
	
		
#func take_damage(damage: int):
	#health -= damage
	#if health < 0: 
		#health = 0
	#healthbar.update_healthbar(-damage)
	#
#func take_health(heal: int):
	#health += health
	#healthbar.update_healthbar(heal)
