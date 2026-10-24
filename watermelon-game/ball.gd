class_name Ball
extends RigidBody2D

@export var radius = 20
@export var ball_color = Color.ORANGE
@onready var shape : CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# collision shape konfigurieren
	contact_monitor = true
	# TODO Kollisionslogik
	
	set_radius(radius)
	
func set_radius(new_radius: float) -> void:
	radius = new_radius
	if shape and shape.shape is CircleShape2D:
		shape.shape.radius = radius
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, ball_color)
	
