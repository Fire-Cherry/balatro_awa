class_name Card
extends Node2D

@onready var drag_component: DragComponent = $DragComponent
@onready var visuals: Control = $Visuals

var z_idx

func _ready() -> void:
	drag_component.drag_started.connect(_on_drag_started)
	drag_component.drag_ended.connect(_on_drag_ended)
	
func _on_drag_started() -> void:
	z_index = 100
	var tween = create_tween().set_parallel(true)
	tween.tween_property(visuals,"scale",Vector2(1.05,1.05),0.1)
	
func _on_drag_ended() -> void:
	z_index = z_idx
	var tween = create_tween().set_parallel(true)
	tween.tween_property(visuals,"scale",Vector2(1.00,1.00),0.1)
	
