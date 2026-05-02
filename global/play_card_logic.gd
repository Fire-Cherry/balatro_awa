extends Node

func _ready() -> void:
	pass
	
func calculate_score(cards:Array[Card]) -> Dictionary:
	var result = {
		"hand_name": "High Card",   # 牌型名称
		"chips": 0,                 # 基础分（含牌型加分）
		"mult": 1,                  # 倍率
		"scoring_cards": []         # 哪些牌参与计分
	}
	
	if cards.is_empty():
		return result
	
	var part_2 = get_x_same_point_card(2, cards)
	var part_3 = get_x_same_point_card(3, cards)
	var part_4 = get_x_same_point_card(4, cards)
	var is_flush = get_flush(cards)
	var is_stright = get_stright(cards)
	
	# 同花顺
	if is_flush and is_stright:
		result.hand_name = "Straight Flush"
		result.chips = 100
		result.mult = 8
		result.scoring_cards = cards
	
	# 四条
	elif part_4.size() > 0:
		result.hand_name = "Four of a Kind"
		result.chips = 60
		result.mult = 7
		result.scoring_cards = part_4[0].cards
	
	# 葫芦
	elif part_2.size() > 0 and part_3.size() > 0:
		result.hand_name = "Full House"
		result.chips = 40
		result.mult = 4
		result.scoring_cards = part_2[0].cards + part_3[0].cards
	
	# 同花
	elif is_flush:
		result.hand_name = "Flush"
		result.chips = 35
		result.mult = 4
		result.scoring_cards = cards
	
	# 顺子
	elif is_stright:
		result.hand_name = "Straight"
		result.chips = 30
		result.mult = 4
		result.scoring_cards = cards
	
	# 三条
	elif part_3.size() > 0:
		result.hand_name = "Three of a Kind"
		result.chips = 20
		result.mult = 3
		result.scoring_cards = part_3[0].cards
	
	# 两对
	elif part_2.size() >= 2:
		result.hand_name = "Two Pair"
		result.chips = 20
		result.mult = 2
		for pair in part_2:
			result.scoring_cards.append_array(pair.cards)
	
	# 一对
	elif part_2.size() == 1:
		result.hand_name = "Pair"
		result.chips = 10
		result.mult = 2
		result.scoring_cards = part_2[0].cards
	
	# 高牌
	else:
		result.hand_name = "High Card"
		result.chips = 5
		result.mult = 1
		var max_card = cards[0]
		for card in cards:  # 高牌最高牌计分
			if card.point > max_card.point:
				max_card = card
		result.scoring_cards = [max_card]
	
	# 加每张牌的点数
	for card in result.scoring_cards:
		result.chips += card.point + 2  # point是0-12，+2变成2-14
	
	return result
	
	
func get_flush(cards:Array[Card]) -> bool:
	if cards.size() < 5:
		return false
		
	var suit = cards[0].suit
	for card in cards:
		if not card.suit == suit:
			return false
			
	return true

func get_stright(cards:Array[Card]) -> bool:
	if cards.size() < 5:
		return false
	
	cards.sort_custom(func(a,b): return a.point < b.point)
	var first = cards[0].point
	for i in range(cards.size()):
		if not cards[i].point == first + i:
			return false
			
	return true
		
func get_x_same_point_card(x:int, cards:Array[Card]) -> Array[Dictionary]:
	var count = {}
	var result: Array[Dictionary] = []
	
	for card in cards:
		if count.has(card.point):
			count[card.point].append(card)
		else:
			count[card.point] = [card]
	
	for point in count:
		if count[point].size() == x:
			result.append({
				"point": point,
				"cards": count[point]
			})
	
	return result
	
			
		
