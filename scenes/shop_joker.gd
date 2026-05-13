class_name ShopJoker
extends Joker

@onready var button: Button = $Button
const JOKER = preload("uid://ousvsh5augvy")

func _ready() -> void:
	super()
	button.text = "Buy " + str(joker_resource.cost) + "$"
	button.button_down.connect(buy_joker)
	
func buy_joker() -> void:
	if Enums.money < joker_resource.cost:
		return
		
	Enums.money -= joker_resource.cost
	Enums.game_joker_resources.append(joker_resource)
	
	self.queue_free()
