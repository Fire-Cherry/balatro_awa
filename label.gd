extends Label

var current_display_value : float = 0.0
var target_value : float = 0.0
var tween : Tween

func _ready():
	pass

func animate_to(new_value: float, duration: float = 0.2):
	# 干掉上一个动画
	if tween:
		tween.kill()
	
	target_value = new_value
	tween = create_tween()
	tween.tween_method(_update_display, current_display_value, target_value, duration)
	# 缓动：开始飞快，结尾缓缓停下
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)

func _update_display(value: float):
	# 数学：每次回调时更新显示为整数
	current_display_value = value
	text = str(int(value))
