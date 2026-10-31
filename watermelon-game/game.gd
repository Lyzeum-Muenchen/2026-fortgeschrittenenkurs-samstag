extends Node2D

var ball_scene = preload("res://Ball.tscn") # Name anpassen!
var rng = RandomNumberGenerator.new()

func _input(event):
	if event is InputEventMouseButton \
		and event.pressed \
		and event.get_button_index() == MOUSE_BUTTON_LEFT:

		var random_number = rng.randi_range(0, 2)
		
		var ball: RigidBody2D = ball_scene.instantiate()
		ball.position = event.position
		ball.position.y = 0
		add_child(ball)
