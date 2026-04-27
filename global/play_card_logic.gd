extends Node

func _ready() -> void:
	pass
	
func check_rank(cards:Array[Card]) -> String:
	if not cards:
		return "No Card"
	var part_2 = get_x_same_point_card(2, cards)
	var part_3 = get_x_same_point_card(3, cards)
	var part_4 = get_x_same_point_card(4, cards)
	
	var is_flush = get_flush(cards)
	var is_stright = get_stright(cards)
	
	if is_flush and is_stright:
		return "Flush Stright"
	if part_4:
		return "Four of a Kind"
	if part_2 and part_3:
		return "Full House"
	if is_flush:
		return "Flush"	
	if is_stright:
		return "Stright"
	if part_3:
		return "Three of a Kind"	
	if part_2.size() > 1:
		return "Two Pair"
	if part_2:
		return "Pair"
	return "High Card"
	
	
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
		
func get_x_same_point_card(x:int,cards:Array[Card]):
	var val = []
	val.resize(13)
	val.fill(0)
	var result = []
	for card in cards:
		val[card.point] += 1
	for i in val:
		if i == x:
			result.append(i)
			
	return result
		
	
			
		
