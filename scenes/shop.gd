extends Node2D

@onready var coin_label: Label = $CoinLabel
@onready var shop_card_manager: ShopCardManager = $ShopCardManager

const MAIN = "res://scenes/main.tscn"
const JOKER = preload("res://scenes/shop_joker.tscn")
const Y_POS = 316

var shop_jokers: Array[ShopJoker]

func _ready() -> void:
	coin_label.text = str(Enums.money)
	create_rand_joker()
	create_rand_joker()
	update_pos(shop_jokers)
	
func _input(event: InputEvent) -> void:
	coin_label.text = str(Enums.money)

func _on_next_stage_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN)

func find_num_of_all_jokers() -> int:
	var dir = DirAccess.open("res://resources/joker/")
	var count = 0
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			count += 1
			file_name = dir.get_next()
		dir.list_dir_end()
	return count

func create_rand_joker() -> void:
	var joker = JOKER.instantiate()
	var count = find_num_of_all_jokers()
	joker.joker_resource = Enums.all_jokers[randi() % (count-2)]
	shop_jokers.append(joker)
	shop_card_manager.add_child(joker)
	
func update_pos(jokers:Array[ShopJoker]) -> void:
	for i in range(jokers.size()):
		var card = jokers[i]
		jokers[i].z_index = i
		var tween = create_tween()
		tween.tween_property(jokers[i], "position", Vector2(915 + i * 219, Y_POS), 0.1)
