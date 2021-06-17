extends "res://Scenes/Characters/Character.gd"


var death_sequence_position = 0


func _physics_process(delta):
	if $RayCast.is_colliding():
		try_to_fire()


func hurt():
	if death_sequence_position == 0:
		$TranslationAnimation.stop()
		death_sequence_advancer()


func _on_DeathAnimationTimer1_timeout():
	death_sequence_advancer()


func death_sequence_advancer():
	if death_sequence_position < 5:
		if death_sequence_position % 2 == 0:
			$RobotArmature.hide()
		else:
			$RobotArmature.show()
		
		death_sequence_position += 1
		$DeathAnimationTimer.start()
	else:
		queue_free()
