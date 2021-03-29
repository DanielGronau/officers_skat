extends Node

enum Loc {HEAP, PLAYER1, PLAYER2, TRICK1, TRICK2}
enum Trump {NONE = -1, ACORN, LEAVES, HEARTS, BELLS, GRAND}
enum PlayerType { HUMAN, WEAK_AI, MEDIUM_AI, STRONG_AI }
enum Suit {ACORN, LEAVES, HEARTS, BELLS}
enum Value {SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE }

var player1: Node2D
var player2: Node2D
var cards: Array = Array()
var card1_played: Node2D = null
var card2_played: Node2D = null

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
	
func change_moving():
	player1.moving = ! player1.moving
	player2.moving = ! player2.moving
	player1.show_moving()
	player2.show_moving()
	
func who_gets_trick():
	var suit1 = card1_played.suit
	var suit2 = card2_played.suit
	var val1 = card1_played.value
	var val2 = card2_played.value
	var trump1 = val1 == Value.JACK || suit1 == trump
	var trump2 = val2 == Value.JACK || suit2 == trump
	if trump1:
		if trump2:
			if val1 == Value.JACK:
				if val2 == Value.JACK && suit1 > suit2:
					return card2_played.loc + 2	
				else:
					return card1_played.loc + 2	
			else:
				if val2 == Value.JACK || val1 < val2:
					return card2_played.loc + 2
				else:
					return card1_played.loc + 2
		else:
			return card1_played.loc + 2
	else: 
		if trump2 || (suit1 == suit2 && val1 < val2):
			return card2_played.loc + 2
		else:
			return card1_played.loc + 2

