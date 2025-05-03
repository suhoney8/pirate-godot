extends Path2D

# Tells if path is closed or open.
@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if not loop:
		# Works for a open path
		animation.play("move")
		animation.speed_scale = speed_scale
		# If it an open path, then process function is not needed
		set_process(false)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Works for a closed path
	path.progress += speed
