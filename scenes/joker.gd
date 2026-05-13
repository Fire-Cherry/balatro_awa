class_name Joker
extends Area2D

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var drag_component: DragComponent = $DragComponent
@onready var visuals: Control = $Visuals
@onready var label: Label = $Visuals/Describe_txt/Label
@onready var describe_txt: Node = $Visuals/Describe_txt

@export var joker_resource: JokerResource

func _ready() -> void:
	set_visual()
	drag_component.drag_started.connect(_on_drag_started)
	drag_component.drag_ended.connect(_on_drag_ended)

func set_visual() -> void:
	sprite_2d.region_rect = joker_resource.set_rect()
	label.text = joker_resource.describe_txt
	describe_txt.visible = false
	
func _on_drag_started() -> void:
	z_index = 100
	var tween = create_tween().set_parallel(true)
	tween.tween_property(visuals,"scale",Vector2(1.05,1.05),0.1)
	
func _on_drag_ended() -> void:
	z_index = 0
	var tween = create_tween().set_parallel(true)
	tween.tween_property(visuals,"scale",Vector2(1.00,1.00),0.1)
	
func _on_mouse_entered() -> void:
	if not drag_component.is_dragging:
		self.scale = Vector2(1.05,1.05)
		describe_txt.visible = true

func _on_mouse_exited() -> void:
	if not drag_component.is_dragging:
		self.scale = Vector2(1.00,1.00)
		describe_txt.visible = false
