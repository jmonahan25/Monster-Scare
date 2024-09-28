extends Camera3D

@export var speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector3.ZERO
	if Input.is_action_pressed("Walk"):
		velocity.x -= 0.01;
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
