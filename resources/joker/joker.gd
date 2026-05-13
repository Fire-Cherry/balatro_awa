class_name JokerResource
extends Resource


@export_group("Attributes")
@export var name: String
@export var texture_pos: Vector2
@export var effect: Enums.Effects
@export var type: Enums.Type
@export var num: int
@export var describe_txt: String
@export var cost: int


func set_rect() -> Rect2:
	var rect = Rect2(texture_pos * Vector2(71,95), Vector2(71,95))
	return rect
