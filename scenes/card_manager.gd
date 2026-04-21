class_name CardManager
extends Node2D

const CARD_Y_POS := 800

@onready var game_manager: GameManager = $"../GameManager"

signal cards_sorted(hand_card:Array[Card])

var hand_card: Array[Card]
var hand_count = 0
var pos_arr: Array[Vector2]
var dragging_card: Card = null

func _ready() -> void:
	await game_manager.ready
	update_pos(hand_card)
	cards_sorted.connect(update_pos)
	
func update_pos(hand_card: Array[Card]) -> void:
	for i in range(hand_card.size()):
		var card = hand_card[i]
		hand_card[i].z_idx = i
		hand_card[i].z_index = i
		var tween = create_tween()
		tween.tween_property(hand_card[i], "position", Vector2(480+960/(hand_card.size()) * i, CARD_Y_POS), 0.1)
	return

func _physics_process(delta: float) -> void:
	if not dragging_card:
		sort_cards_by_x()
		update_pos(hand_card)

func request_drag(card: Card) -> bool:
	var up_card = ray_cast_check()
	if dragging_card == null and card == up_card:
		dragging_card = card
		return true
	return false
	
func end_drag(card: Card) -> void:
	if dragging_card == card:
		dragging_card = null

func ray_cast_check() -> Node:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1

	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_highest_z_index_card(result)
	return null
	
func get_highest_z_index_card(arr:Array[Dictionary]) -> Node:
	var highest_card = arr[0].collider
	var highest_z = highest_card.z_index
	for i in range(arr.size()):
		if arr[i].collider.z_index > highest_z:
			highest_card = arr[i].collider
			highest_z = arr[i].collider.z_index
	
	return highest_card

func sort_cards_by_x() -> void:
	hand_card.sort_custom(func(a,b): return a.position.x < b.position.x)
