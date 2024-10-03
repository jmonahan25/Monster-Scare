extends Camera3D

@export var speed = 20
var footsteps = preload("res://heavy-footsteps-walking-35722.mp3")
var win_sound = preload("res://cartoon_scream.wav")  # Make sure to add this sound file
var playback = 1.00
var is_moving = false

@onready var audio_player = $AudioStreamPlayer3D

func _ready():
	if not audio_player:
		audio_player = AudioStreamPlayer3D.new()
		add_child(audio_player)

func _process(delta):
	var velocity = Vector3.ZERO
	is_moving = false

	if Input.is_action_pressed("Walk"):
		velocity.x -= 0.01
		is_moving = true
		if !audio_player.is_playing():
			audio_player.stream = footsteps
			audio_player.play(playback)
	elif Input.is_action_just_released("Walk"):
		playback = audio_player.get_playback_position()
		audio_player.stop()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta

func _on_bed_area_entered(area):
	if area.is_in_group("bed"):
		win_game()

func win_game():
	audio_player.stream = win_sound
	audio_player.play()
	print("Congratulations! You won!")
	await audio_player.finished
	get_tree().reload_current_scene()
