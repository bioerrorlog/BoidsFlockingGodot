extends RigidBody2D

func _physics_process(delta):
	if position.y >= 600:
		gravity_scale = -200
	else:
		gravity_scale = 0.5
