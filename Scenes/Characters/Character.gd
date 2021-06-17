extends KinematicBody

# Default fire projectile collision mask; won't interact with robots but does with player
var projectile_collision_mask = 0x77
var food_types = {}
var can_fire = true

const PROJECTILE_SPEED = 50


func _ready():
	food_types = FileGrabber.get_files("res://Projectiles/Food_Types/")
	randomize()


func try_to_fire():
	if can_fire == true:
		fire()
		can_fire = false
		$FiringCooldown.start()


func fire():
	var random_food = food_types[randi() % food_types.size()]
	var projectile = load(random_food).instance()
	print(projectile)
	projectile.set_projectile_mask(projectile_collision_mask)
	add_child(projectile)
	projectile.set_as_toplevel(true)
	projectile.global_transform = $Forward.global_transform
	var character_forward = global_transform.basis[2].normalized()
	projectile.linear_velocity = character_forward * PROJECTILE_SPEED


func _on_FiringCooldown_timeout():
	can_fire = true


