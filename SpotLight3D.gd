extends SpotLight3D

@export var length: float = 10.0
@export_range(0.0, 1.0, 0.01) var falloff: float = 1.0
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.2

var _cone_mesh: MeshInstance3D = null

# Configuration variables
var rotation_speed = 2.0  # Speed of rotation
var min_angle = deg_to_rad(-105)  # Minimum angle in radians
var max_angle = deg_to_rad(-75)   # Maximum angle in radians

# Internal state variables
var direction = 1  # 1 = rotating towards max_angle, -1 = rotating towards min_angle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_cone_mesh = MeshInstance3D.new()
	var cylinder = CylinderMesh.new()
	cylinder.material = build_material()

	_cone_mesh.mesh = cylinder
	_cone_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	add_child(_cone_mesh)
	update_position()
	update_cone()

func build_material() -> StandardMaterial3D:
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var grad = Gradient.new()
	grad.set_color(0, Color(light_color, opacity))
	grad.set_color(1, Color(light_color, 0.0))
	var grad_tex = GradientTexture2D.new()
	grad_tex.gradient = grad
	grad_tex.fill_from = Vector2(0.0, 0.0)
	grad_tex.fill_to = Vector2(0.0, 0.5 * falloff)
	mat.albedo_texture = grad_tex
	return mat

func update_position() -> void:
	_cone_mesh.rotation.x = PI * 0.5
	_cone_mesh.position.z = length * -0.5

func update_cone() -> void:
	var a = deg_to_rad(spot_angle)
	var b = PI * 0.5
	var c = PI - (a + b)
	_cone_mesh.mesh.top_radius = 0.0
	_cone_mesh.mesh.bottom_radius = length * sin(a) / sin(c)
	_cone_mesh.mesh.height = length

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the current rotation along the Y-axis
	rotation_degrees.y += direction * rotation_speed * delta*abs(rotation_degrees.y-90)/90
	
	# Check if the rotation has reached or exceeded the boundaries
	if rotation_degrees.y >= rad_to_deg(max_angle):
		rotation_degrees.y = rad_to_deg(max_angle)
		direction = -1  # Switch direction to rotate back
	elif rotation_degrees.y <= rad_to_deg(min_angle):
		rotation_degrees.y = rad_to_deg(min_angle)
		direction = 1  # Switch direction to rotate forward
pass
