extends Node

enum Loc {HEAP, PLAYER1, PLAYER2, TRICK1, TRICK2}
enum Trump {NONE = -1, ACORN, LEAVES, HEARTS, BELLS, GRAND}
enum PlayerType { HUMAN, WEAK_AI, MEDIUM_AI, STRONG_AI }
enum Suit {ACORN, LEAVES, HEARTS, BELLS}
enum Value {SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE }

var player1: Node2D
var player2: Node2D
var cards: Array = Array()

var trump: int = Trump.NONE

func _ready():
	createCards()
	
func createCards():
	var scene = preload("res://Cards/Card.tscn")
	for suite in 4:
		for value in 8:
			var card = scene.instance()
			card.name = "Card" + str(suite) + str(value)
			cards.append(card)
			card.init(suite, value, false)
	randomize()		
	cards.shuffle()	
	
