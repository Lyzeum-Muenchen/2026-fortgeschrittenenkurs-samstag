class_name Ball
extends RigidBody2D

@export var radius = 20
@export var color_index = 0
@onready var shape : CollisionShape2D = $CollisionShape2D

const color_levels = [
	Color("#ff6b6b"),
	Color("#fa5252"),
	Color("#fd7e14"),
	Color("#fcc419"),
	Color("#40c057"),
	Color("#12b886"),
	Color("#339af0"),
	Color("#7950f2")
]

func _ready() -> void:
	# collision shape konfigurieren
	contact_monitor = true
	max_contacts_reported = 4
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	if shape:
		shape.shape = CircleShape2D.new()
		shape.shape.radius = radius
	
	set_radius(radius)
	body_entered.connect(_on_body_entered)
	
func set_radius(new_radius: float) -> void:
	radius = new_radius
	if shape and shape.shape is CircleShape2D:
		shape.shape.radius = radius
	queue_redraw()

func _draw() -> void:
	var selected_color = color_levels[color_index]
	draw_circle(Vector2.ZERO, radius, selected_color)
	
func _on_body_entered(body: Node) -> void:
	if body is Ball \
		and self.get_instance_id() < body.get_instance_id() \
		and self.radius == body.radius:
			_merge_body(body)

func _merge_body(other_ball: Ball) -> void:
	if not is_instance_valid(self) or not is_instance_valid(other_ball):
		return
	
	# neue Position und Geschwindigkeit berechnen
	global_position =  (global_position + other_ball.global_position) / 2
	color_index = min(color_index + 1, color_levels.size() - 1)
	
	set_radius(radius * 1.3)
	linear_velocity = (linear_velocity + other_ball.linear_velocity) / 2
	
	other_ball.queue_free()
	
	
