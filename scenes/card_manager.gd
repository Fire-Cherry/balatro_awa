class_name CardManager
extends Node2D

const CARD_Y_POS := 800
const MIN_CLICK_DIST = 5

@onready var game_manager: GameManager = $"../GameManager"
@onready var ranking: Label = $"../CanvasLayer/Ranking"

signal cards_sorted(hand_card:Array[Card])

var click_start_pos: Vector2
var is_mouse_pressed: bool = false
var hand_card: Array[Card]
var selected_card: Array[Card]
var hand_count = 0
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
		tween.tween_property(hand_card[i], "position", Vector2(480+960/(hand_card.size()) * i, CARD_Y_POS - card.offset), 0.1)
	return

func _input(event: InputEvent) -> void:
	var can_select = selected_card.size() < 5
	#选中卡牌 加入选中 最后判断是否是要取消 然后执行
	#这一串语句，直接解决卡牌选中与删除，并且逻辑自洽得让update_pos顺利执行，应当反复斟酌
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_mouse_pressed = true
			click_start_pos = get_global_mouse_position()
		elif event.is_released() and is_mouse_pressed:
			is_mouse_pressed = false
			if (get_global_mouse_position() - click_start_pos).length() < MIN_CLICK_DIST:
				var card = ray_cast_check()
				if card and card is Card:
					if selected_card.has(card):
						card.offset = 0
						selected_card.erase(card)
					elif selected_card.size() < 5:
						card.offset = 20
						selected_card.append(card)
	#检测卡牌
	if not dragging_card and not game_manager.is_scoring:
		sort_cards_by_x(hand_card)
		sort_cards_by_x(selected_card)
		update_pos(hand_card)
	
	if selected_card and not game_manager.is_scoring:
		var rank: String = PlayLogic.calculate_score(selected_card).hand_name
		game_manager.set_ranking(rank)
	
		

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

func sort_cards_by_x(cards:Array[Card]) -> void:
	cards.sort_custom(func(a,b): return a.position.x < b.position.x)

func sort_cards_by_point() -> void:
	hand_card.sort_custom(func(a,b): return a.point > b.point)
	
func sort_cards_by_club() -> void:
	hand_card.sort_custom(func(a,b): return a.suit > b.suit)
	
#此处迭代时erase会直接改变数组长度从而改变迭代次数，所以会造成下次还有卡牌选中的现象(AI如是说)
func drop_card() -> void:
	if selected_card.is_empty():
		return
	
	for _card in selected_card:
		hand_count -= 1
		_card.queue_free()
		hand_card.erase(_card)
	
	selected_card.clear()
	game_manager.draw_card(game_manager.hand_num - hand_count)
	sort_cards_by_point()
	update_pos(hand_card)


func sort_card_point() -> void:
	sort_cards_by_point()
	update_pos(hand_card)

func sort_card_suit() -> void:
	sort_cards_by_club()
	update_pos(hand_card)



	
	
