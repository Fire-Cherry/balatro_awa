extends Node

#全局的各种东西都写在这

const score_map = [300,450,600,1000,1200]

const TYPE_TXT = ["High Card", "Pair", "Two Pair", "Three of a Kind", "Straight", "Flush", "Full House", "Four of a Kind", "Straight Flush"]

enum Effects {Mult,Chips,TypeMult,TypeChips,XMult}
enum Type {High_Card, Pair, Two_Pair, Three_of_a_Kind, Straight, Flush, Full_House, Four_of_a_Kind, Straight_Flush}

var money := 5
var game_joker_resources: Array[JokerResource]
var now_stage := 0

@export var all_jokers: Array[JokerResource]

func _ready() -> void:
	auto_load_joker_resources("res://resources/joker/")

func auto_load_joker_resources(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var file_path = path + file_name
				var joker = ResourceLoader.load(file_path, "JokerResource")
				if joker:
					all_jokers.append(joker)
				else:
					push_error("Cant load Joker resources")
					
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Cant find path")
