extends Node2D

var ball_scene = preload("res://Ball.tscn") # Name anpassen!
var rng = RandomNumberGenerator.new()
var next_ball: RigidBody2D
@onready var score_label = $ScoreLabel
@onready var highscore_label = $HighscoreLabel

@export var score = 0:
	set(new_value):
		score = new_value
		score_label.text = "Score: " + str(new_value)
		if score > highscore:
			highscore = score

var highscore = 0:
	set(new_value):
		var is_new_highscore = new_value > highscore and new_value > 0
		if is_new_highscore:
			save_highscore(new_value)
			highscore = new_value
		highscore_label.text = "Highscore: " + str(highscore)
		
			
func _ready() -> void:
	next_ball = generate_new_ball(true)
	load_highscore()

func load_highscore():
	var file_path = "highscore.txt"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var content = file.get_as_text()
		highscore = int(content)


func save_highscore(value):
	var file_path = "highscore.txt"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(str(value))


func _input(event):
	# if not is_instance_valid(next_ball):
	# 	return
	if event is InputEventMouseMotion:
		next_ball.position.x = event.position.x
		next_ball.position.y = 50
		
	if event is InputEventMouseButton \
		and event.pressed \
		and event.get_button_index() == MOUSE_BUTTON_LEFT:
		
		var ball = next_ball
		ball.freeze = false
		ball.position = event.position
		ball.position.y = 50
		ball.get_node("CollisionShape2D").disabled = false
		
		next_ball = generate_new_ball(false)


func generate_new_ball(generate_smallest_ball: bool) -> RigidBody2D:
	var new_ball: RigidBody2D = ball_scene.instantiate()
	var random_number = rng.randi_range(0, 2)
	if generate_smallest_ball:
		random_number = 0
	new_ball.color_index = random_number
	new_ball.position.x = get_viewport().get_mouse_position().x
	new_ball.position.y = 50
	new_ball.freeze = true
	new_ball.get_node("CollisionShape2D").disabled = true
	add_child(new_ball)
	return new_ball
