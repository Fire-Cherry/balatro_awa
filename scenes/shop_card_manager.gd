class_name ShopCardManager
extends Node2D

var jokers: Array[Joker]
var dragging_card: Joker = null

func request_drag(card: Joker) -> bool:
	if dragging_card == null:
		dragging_card = card
		return true
	return false
	
func end_drag(card: Joker) -> void:
	if dragging_card == card:
		dragging_card = null
