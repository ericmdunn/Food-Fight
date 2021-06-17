extends "res://Scenes/Characters/Character.gd"


const SPEED = 10
const UP = Vector3(0, 1, 0)

const MIN_BLEND_SPEED = 0.125 # Minimum movement threshold before we start blending animations
const BLEND_TO_RUN = 0.075
const BLEND_TO_IDLE = 0.1


var motion = Vector3()
var movement_state = 0 # Idle is zero, run is one
var mouse_sensitivity = 500


func _ready():
	# Collision mask for fired projectiles; they interact with robots but not player
	projectile_collision_mask = 0x7d
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	move()
	animate()


func _input(event):
	if event is InputEventMouseMotion:
		rotation = h_camera_rotation(-event.relative.x/mouse_sensitivity)
		$Camera.rotation = v_camera_rotation(-event.relative.y/mouse_sensitivity)
	
	if Input.is_action_just_pressed("fire"):
		try_to_fire()


func move():
	var movement_dir = get_2D_movement_dir()
	var direction = Vector3.ZERO
	var camera_transform = $Camera.global_transform
	
	direction -= camera_transform.basis.z.normalized() * movement_dir.x
	direction += camera_transform.basis.x.normalized() * movement_dir.y
	direction.y = 0
	
	motion = direction
	
	move_and_slide(motion * SPEED, UP)


func get_2D_movement_dir():
	var x = Input.get_action_strength("forward") - Input.get_action_strength("back")
	var y = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	var movement_direction = Vector2(x, y)
	
	if not movement_direction == Vector2.ZERO:
		face_forward(x, y)
	
	return movement_direction.normalized()



func face_forward(x, y):
	$Armature.rotation.y = atan2(x, y) - PI/2


func animate():
	if (motion * SPEED).length() > MIN_BLEND_SPEED:
		movement_state += BLEND_TO_RUN
	else:
		movement_state -= BLEND_TO_IDLE
	
	movement_state = clamp(movement_state, 0, 1)
	var animation = $Armature/AnimationTree
	
	animation["parameters/Move/blend_amount"] = movement_state


func h_camera_rotation(camera_rotation):
	return rotation + Vector3(0, camera_rotation, 0)


func v_camera_rotation(camera_rotation):
	var rot = $Camera.rotation + Vector3(camera_rotation, 0, 0)
	rot.x = clamp(rot.x, -PI/2, PI/2)
	return rot

