extends Node2D

@onready var coin_label: Label = $CoinLabel

const MAIN = "res://scenes/main.tscn"

func _ready() -> void:
	coin_label.text = str(Enums.money)
	
func _input(event: InputEvent) -> void:
	coin_label.text = str(Enums.money)

func _on_next_stage_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN)
