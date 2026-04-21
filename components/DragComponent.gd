class_name DragComponent
extends Node

@export var area: Area2D

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var _parent: Node :
	get:
		return get_parent()

signal drag_started
signal drag_ended

func _ready() -> void:
	if is_instance_valid(area):
		area.input_event.connect(_on_drag_area_input)
	else:
		push_error("DragComponent must have an area")
		
func _physics_process(delta: float) -> void:
	if is_dragging:
		_parent.position = _parent.get_global_mouse_position() - drag_offset
	
	
func _input(event: InputEvent) -> void:
	if not is_dragging:
		return
	var card = get_parent()
	var manager = card.get_parent()
	if event is InputEventMouseButton and not event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = false
			manager.end_drag(card)
			drag_ended.emit()
			
func _on_drag_area_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var card = get_parent()
		var manager = card.get_parent()
		if event.is_pressed() and not is_dragging and manager.request_drag(card):
			is_dragging = true
			drag_started.emit()
			drag_offset = _parent.get_global_mouse_position() - _parent.global_position
			
			
		
