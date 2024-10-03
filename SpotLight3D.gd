extends SpotLight3D

# Export variables for easy adjustment in the Inspector
@export var length: float = 10.0
@export_range(0.0, 1.0, 0.01) var falloff: float = 1.0
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.2

# Preload sound effects
@onready var flash_sound = preload("res://heavy_click.mp3")
@onready var lose_sound = preload("res://lose_game.wav")  # Make sure to add this sound file

# Get reference to the AudioStreamPlayer3D child node
@onready var audio_player = $AudioStreamPlayer3D

# Timer for controlling light flashes
var flash_timer: Timer
var is_flashing: bool = false

func _ready():
	# Create AudioStreamPlayer3D if it doesn't exist
	if not audio_player:
		audio_player = AudioStreamPlayer3D.new()
		add_child(audio_player)
	
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
	var wait_time = randf_range(1.0, 3.0) if not is_flashing else randf_range(3.0, 8.0)
	flash_timer.start(wait_time)

func _on_flash_timer_timeout():
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

func _process(delta):
	# Check if the light is on and the player is pressing the spacebar
	if is_flashing and Input.is_action_pressed("Walk"):
		lose_game()

func lose_game():
	# Play the lose sound
	audio_player.stream = lose_sound
	audio_player.play()
	print("Game Over! You lost.")
	
	# Wait for the sound to finish playing before restarting
	await audio_player.finished
	
	# Restart the game
	get_tree().reload_current_scene()
