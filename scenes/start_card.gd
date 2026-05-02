class_name StartCard
extends Area2D

@onready var drag_component: DragComponent = $DragComponent
@onready var visuals: Sprite2D = $Visuals

var offset = 0
var start_pos: Vector2

func _ready() -> void:
	drag_component.drag_started.connect(_on_drag_started)
	drag_component.drag_ended.connect(_on_drag_ended)
	start_pos = self.position
	
func _on_drag_started() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(visuals,"scale",Vector2(1.05,1.05),0.1)
	
func _on_drag_ended() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(visuals,"scale",Vector2(1.00,1.00),0.1)
	tween.tween_property(self, "position", start_pos, 0.2)
