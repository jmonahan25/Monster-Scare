extends SpotLight3D

# Export variables for easy adjustment in the Inspector
@export var length: float = 10.0
@export_range(0.0, 1.0, 0.01) var falloff: float = 1.0
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.2

# Preload sound effects
@onready var flash_sound = preload("res://flashlight_click.wav")
@onready var rustle_sound = preload("res://duvet-rustle-weightier-various-76234.mp3")
@onready var lose_sound = preload("res://lose_game.wav")  # Make sure to add this sound file

# Get reference to the AudioStreamPlayer3D child node
@onready var audio_player = $AudioStreamPlayer3D

# Timer for controlling light flashes
var flash_timer: Timer
var is_flashing: bool = false

@onready var LoseText = $LoseText/LoseTextSprite
@onready var WinText = $WinText/WinTextSprite
@onready var camera = $Camera3D

func _ready():
	# Create AudioStreamPlayer3D if it doesn't exist
	if not audio_player:
		audio_player = AudioStreamPlayer3D.new()
		add_child(audio_player)
	
	LoseText.visible = false
	WinText.visible = false
	# Set up the flash timer
	flash_timer = Timer.new()
	add_child(flash_timer)
	flash_timer.connect("timeout", Callable(self, "_on_flash_timer_timeout"))
	
	# Start the flashing sequence
	start_flashing()

func start_flashing():
	# Initialize the light as off
	is_flashing = false
	self.visible = false
	set_next_flash()

func set_next_flash():
	# Set a random duration for the next state (on or off)
	var wait_time = randf_range(3.0, 5.0) if not is_flashing else randf_range(2.0, 3.0)
	flash_timer.start(wait_time)

func _on_flash_timer_timeout():
	audio_player.stream = rustle_sound
	audio_player.play()
	audio_player.stream = flash_sound
	audio_player.play()
	
	# Toggle the flashing state
	is_flashing = not is_flashing
	self.visible = is_flashing
	
	if is_flashing:
		# Play the flash sound when the light turns on
		audio_player.stream = flash_sound
		audio_player.play()
	else:
		# Stop the sound when the light turns off
		audio_player.stop()
	
	# Set the timer for the next flash
	set_next_flash()

func _process(_delta):
	# Check if the light is on and the player is pressing the spacebar
	if is_flashing and Input.is_action_pressed("Walk"):
		lose_game()
	var camPos = camera.global_position
	if camPos.x < -27.0:
		win_game()

func win_game():
	WinText.visible = true

func lose_game():
	# Play the lose sound
	LoseText.visible = true 
	audio_player.stream = lose_sound
	audio_player.play()
	print("Game Over! You lost.")
	
	# Wait for the sound to finish playing before restarting
	await audio_player.finished
	
	# Restart the game
	get_tree().reload_current_scene()
