extends SpotLight3D

@export var length: float = 10.0
@export_range(0.0, 1.0, 0.01) var falloff: float = 1.0
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.2

# Sound effect variables
@onready var flash_sound = preload("res://heavy_click.mp3")
var audio_player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()

# Flash timing variables
var flash_timer: Timer = Timer.new()
var is_flashing: bool = false

func _ready() -> void:
	add_child(audio_player)
	audio_player.stream = flash_sound
	
	add_child(flash_timer)
	flash_timer.connect("timeout", Callable(self, "_on_flash_timer_timeout"))
	
	start_flashing()

func start_flashing() -> void:
	is_flashing = false
	self.visible = false
	set_next_flash()

func set_next_flash() -> void:
	var wait_time = randf_range(1.0, 3.0) if not is_flashing else randf_range(3.0, 8.0)
	flash_timer.start(wait_time)

func _on_flash_timer_timeout() -> void:
	is_flashing = not is_flashing
	self.visible = is_flashing
	
	if is_flashing:
		audio_player.play()
	else:
		audio_player.stop()
	
	set_next_flash()
