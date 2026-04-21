class_name Card
extends Node2D

enum Suits {HEART, CLUB, DIAMOND, SPADE}
enum Points {
	TWO   = 0,
	THREE = 1,
	FOUR  = 2,
	FIVE  = 3,
	SIX   = 4,
	SEVEN = 5,
	EIGHT = 6,
	NINE  = 7,
	TEN   = 8,
	JACK  = 9,
	QUEEN = 10,
	KING  = 11,
	ACE   = 12
}

@onready var drag_component: DragComponent = $DragComponent
@onready var visuals: Control = $Visuals
@onready var base: Sprite2D = $Visuals/Base
@onready var points: Sprite2D = $Visuals/Points

var z_idx
var point: Points
var suit: Suits
var score

func _ready() -> void:
	drag_component.drag_started.connect(_on_drag_started)
	drag_component.drag_ended.connect(_on_drag_ended)
	print("set_visual")
	set_visual()
	
func _on_drag_started() -> void:
	z_index = 100
	var tween = create_tween().set_parallel(true)
	tween.tween_property(visuals,"scale",Vector2(1.05,1.05),0.1)
	
func _on_drag_ended() -> void:
	z_index = z_idx
	var tween = create_tween().set_parallel(true)
	tween.tween_property(visuals,"scale",Vector2(1.00,1.00),0.1)
	
func set_visual() -> void:
	points.region_rect = Rect2(point*142, suit*190, 142, 190)
