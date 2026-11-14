extends Node2D

var ball_scene = preload("res://Ball.tscn") # Name anpassen!
var rng = RandomNumberGenerator.new()
var next_ball

func _ready() -> void:
	next_ball = generate_new_ball()
	
func generate_new_ball() -> RigidBody2D:
	var new_ball: RigidBody2D = ball_scene.instantiate()
	var random_number = rng.randi_range(0, 2)
	new_ball.color_index = random_number
	new_ball.position.x = get_viewport().get_mouse_position().x
	new_ball.position.y = 50
	new_ball.freeze = true
	new_ball.get_node("CollisionShape2D").disabled = true
	add_child(new_ball)
	return new_ball

func _input(event):
	if event is InputEventMouseMotion:
		next_ball.position.x = event.position.x
		next_ball.position.y = 50
	if event is InputEventMouseButton \
		and event.pressed \
		and event.get_button_index() == MOUSE_BUTTON_LEFT:

		var ball = next_ball
		ball.freeze = false
		ball.get_node("CollisionShape2D").disabled = false
		
		next_ball = generate_new_ball()
