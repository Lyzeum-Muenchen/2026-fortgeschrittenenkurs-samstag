class_name Ball
extends RigidBody2D

var base_radius = 20
@export var radius = 20
@export var size_index: int = 0:
	set(new_value):
		size_index = new_value
		update_radius()
		queue_redraw()

const TEXTURE_PATHS : Array[Texture2D] = [
	preload("res://assets/01_cherry.png"),
	preload("res://assets/02_strawberry.png"),
	preload("res://assets/03_grape.png"),
	preload("res://assets/04_apple.png"),
	preload("res://assets/05_mandarine.png"),
	preload("res://assets/06_peach.png"),
	preload("res://assets/07_pumpkin.png"),
	preload("res://assets/08_watermelon.png"),
]

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
	
	update_radius()
	body_entered.connect(_on_body_entered)
	
func update_radius() -> void:
	radius = get_radius(size_index + 1)
	if shape and shape.shape is CircleShape2D:
		shape.shape.radius = radius
	queue_redraw()

func _draw() -> void:
	var safe_index := clampi(size_index, 0, TEXTURE_PATHS.size() - 1)
	var tex: Texture2D = TEXTURE_PATHS[safe_index]
	if tex == null:
		return

	# Kreisdurchmesser = radius * 2; Rect so setzen, dass der Mittelpunkt bei (0, 0) liegt
	var diameter : float = radius * 2.0
	var rect = Rect2(Vector2(-radius, -radius), Vector2(diameter, diameter))
	draw_texture_rect(tex, rect, false)
	
func _on_body_entered(body: Node) -> void:
	if body is Ball \
		and self.get_instance_id() < body.get_instance_id() \
		and self.radius == body.radius:
			_merge_body(body)

func get_radius(index: int) -> float:
	if index == 0:
		return base_radius
	return get_radius(index - 1) * 1.3


func _merge_body(other_ball: Ball) -> void:
	if not is_instance_valid(self) or not is_instance_valid(other_ball):
		return
	update_radius()
	# neue Position und Geschwindigkeit berechnen
	global_position =  (global_position + other_ball.global_position) / 2
	size_index = min(size_index + 1, color_levels.size() - 1)
	
	linear_velocity = (linear_velocity + other_ball.linear_velocity) / 2
	var game = get_node("/root/Game")
	game.score += 1
	other_ball.queue_free()
	
	
