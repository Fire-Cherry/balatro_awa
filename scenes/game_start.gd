class_name StartScene
extends Node2D

const game_scene = preload("res://scenes/main.tscn")

var dragging_card: StartCard

func _on_button_button_down() -> void:
	get_tree().change_scene_to_packed(game_scene)

func request_drag(card: StartCard) -> bool:
	if dragging_card == null:
		dragging_card = card
		return true
	return false
	
func end_drag(card: StartCard) -> void:
	if dragging_card == card:
		dragging_card = null
