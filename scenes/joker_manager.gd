class_name JokerManager
extends Node2D

var jokers: Array[Joker]
var dragging_card: Joker = null

func _ready() -> void:
	jokers.clear()
	for resource in Enums.game_joker_resources:
		var joker = preload("res://scenes/joker.tscn").instantiate()
		joker.joker_resource = resource
		jokers.append(joker)
		self.add_child(joker)
	update_pos(jokers)
		
func update_pos(hand_card: Array[Joker]) -> void:
	for i in range(hand_card.size()):
		var card = hand_card[i]
		var tween = create_tween()
		tween.tween_property(hand_card[i], "position", Vector2(480+480/(hand_card.size()) * i, 150), 0.1)
	return

func request_drag(card: Joker) -> bool:
	if dragging_card == null:
		dragging_card = card
		return true
	return false
	
func end_drag(card: Joker) -> void:
	if dragging_card == card:
		dragging_card = null
