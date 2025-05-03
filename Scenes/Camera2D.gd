extends Camera2D
@export var speed: float = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_right"):
		position.x += speed * delta
	if Input.is_action_pressed("camera_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("camera_down"):
		position.y += speed * delta
	if Input.is_action_pressed("camera_up"):
		position.y -= speed * delta
