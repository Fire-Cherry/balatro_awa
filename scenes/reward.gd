class_name RewardRoom
extends Node2D

const shop_scene = preload("res://scenes/shop.tscn")
@onready var coin_label: Label = $CoinLabel


func _ready() -> void:
	coin_label.text = str(Enums.money)

func _on_button_button_down() -> void:
	Enums.money += 5
	get_tree().change_scene_to_packed(shop_scene)
