extends Camera3D

@export var speed = 20
var footsteps = load("res://heavy-footsteps-walking-35722.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector3.ZERO
	if Input.is_action_pressed("Walk"):
		velocity.x -= 0.01;
		if !$AudioStreamPlayer3D.is_playing():
			$AudioStreamPlayer3D.stream = footsteps
			$AudioStreamPlayer3D.play()
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
