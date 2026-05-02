class_name GameManager
extends Node2D
#临时数据前面加个_
#这里面大部分关于实例化，设置等知识我都只是一知半解找AI学的
#回头仔细学习估量一下节点的创建，实例化，添加等

const rank_list = {
	"High Card" = [5,1],
	"Pair" = [10,2],
	"Two Pair" = [20,2],
	"Three of a Kind" = [30,3],
	"Straight" = [30,4],
	"Flush" = [35,4],
	"Full House" = [40,4],
	"Four of a Kind" = [60,7],
	"Flush Straight" = [100,8]
}

const reward_room = preload("res://scenes/reward.tscn")

var goal := 300
var now_chips := 0
var now_mult := 0
var now_score := 0
var hand_num := 8
var deck: Array[Card]
var temp_deck: Array[Card]
var _card_scene = preload("res://scenes/card.tscn")
var is_scoring := false

@onready var card_manager: CardManager = $"../CardManager"
@onready var ranking: Label = $"../CanvasLayer/Ranking"
@onready var chips_label: Label = $"../CanvasLayer/ChipsLabel"
@onready var score_label: Label = $"../CanvasLayer/ScoreLabel"
@onready var mult_label: Label = $"../CanvasLayer/MultLabel"
@onready var goal_label: Label = $"../CanvasLayer/GoalLabel"

func _ready() -> void:
	deck = create_deck()
	temp_deck = deck
	draw_card(hand_num - card_manager.hand_count)
	goal_label.text = str(goal)

func create_deck() -> Array[Card]:
	var _deck: Array[Card]
	for i in range(Card.Suits.size()):      # i 是 0, 1, 2, 3
		for j in range(Card.Points.size()):  # j 是 0, 1, 2 ... 12
			var _card = _card_scene.instantiate()
			#TODO 学习知识，如果for i in Suits那获取的都是字符串
			_card.suit = i as Card.Suits      # 转换为枚举类型
			_card.point = j as Card.Points    # 转换为枚举类型
			_deck.append(_card)
	return _deck

#TODO 抽牌系统 得有随机
func draw_card(count: int) -> void:
	if temp_deck.size() == 0:
		return
	if temp_deck.size() < count:
		count = temp_deck.size()
	
	for i in count:
		card_manager.hand_count += 1
		var random_index = randi_range(0,temp_deck.size() - 1)
		var _card = temp_deck[random_index]
		temp_deck.remove_at(random_index)
		add_card(_card.suit,_card.point)
		

func add_card(suit, point) -> void:
	var new_card = _card_scene.instantiate()
	new_card.suit = suit
	new_card.point = point
	card_manager.hand_card.append(new_card)
	card_manager.add_child(new_card)
	
	#后面这是AI解决加入牌的问题 应该是顺序什么的有问题 道理就是把牌添加的时候直接添加位置数据放置
	var index = card_manager.hand_card.size() - 1
	var divisor = max(card_manager.hand_card.size() - 1, 1)
	var target_x = 480.0 + 960.0 / divisor * index
	new_card.global_position = Vector2(target_x, 800)
	
	card_manager.update_pos(card_manager.hand_card)

func set_ranking(rank:String) -> void:
	ranking.text = rank
	now_chips = rank_list[rank][0]
	now_mult = rank_list[rank][1]
	chips_label.text = str(now_chips)
	mult_label.text = str(now_mult)
	


func play_card() -> void:
	#我发现这个await一个计时器和动画什么的真的是很好的一些个东西啊
	#反正就是产生效果不那么突兀又简单的好助手
	if card_manager.selected_card.is_empty():
		return
	
	is_scoring = true
	var score_result = PlayLogic.calculate_score(card_manager.selected_card)
	card_manager.sort_cards_by_x(card_manager.selected_card)
	for i in card_manager.selected_card.size():
		var tween = create_tween()
		tween.tween_property(card_manager.selected_card[i], "position", 
							Vector2(480+960/(card_manager.selected_card.size()) * i, 500), 0.5)
	
	await get_tree().create_timer(0.5).timeout
	
	for card in score_result.scoring_cards:
		var tween = create_tween()
		tween.tween_property(card, "scale", Vector2(1.2, 1.2), 0.15)
		tween.tween_property(card, "scale", Vector2(1.0, 1.0), 0.1)
		
		now_chips += (card.point + 2)
		chips_label.text = str(now_chips)
		
		await tween.finished
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(0.2).timeout
	
	now_score += now_chips * now_mult
	score_label.text = str(now_score)
	card_manager.drop_card()
	is_scoring = false
	
	if now_score > goal:
		get_tree().change_scene_to_packed(reward_room)
	
func highlight_card(card:Card) -> void:
	card.position.y -= 15
