extends RigidBody


func _on_ProjectileTemplate_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.has_method("hurt") and (body.collision_layer & collision_mask):
		body.hurt()
		queue_free()


func set_projectile_mask(new_collision_mask):
	collision_mask = new_collision_mask
	print(collision_mask)
