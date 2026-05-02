class_name RewardRoom
extends Node2D

const shop_scene = preload("res://scenes/shop.tscn")




func _on_button_button_down() -> void:
	get_tree().change_scene_to_packed(shop_scene)
