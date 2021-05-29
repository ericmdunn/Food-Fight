extends Spatial


const MAX_WAIT = 5
const MIN_WAIT = .6
const SPEED = 10


var bystanders = {}


func _ready():
	bystanders = FileGrabber.get_files("res://Bystanders/Bystander_figures/")
	randomize()
	set_timer()


func set_timer():
	$Timer.wait_time = randi() % MAX_WAIT + MIN_WAIT


func _on_Timer_timeout():
	set_timer()
	spawn()


func spawn():
	var bystander = load(bystanders[randi()%bystanders.size()]).instance()
	add_child(bystander)
	bystander.set_as_toplevel(true)
	bystander.global_transform = $Forward.global_transform
	var spawner_forward = global_transform.basis[2].normalized()
	print($Forward.global_transform)
	print(global_transform.basis[2])
	bystander.linear_velocity = spawner_forward * SPEED
	



