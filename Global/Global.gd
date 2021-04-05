extends Node

enum Loc {HEAP, PLAYER1, PLAYER2, TRICK1, TRICK2}
enum Trump {NONE = -1, ACORN, LEAVES, HEARTS, BELLS, GRAND}
enum PlayerType {HUMAN, WEAK_AI, MEDIUM_AI, STRONG_AI }
enum Suit {ACORN, LEAVES, HEARTS, BELLS}
enum Value {SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE }

var player1: Player
var player2: Player
var cards: Array = Array()
var card1_played: Card = null
var card2_played: Card = null

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
	
func show_players(switch: bool):
	if switch:
		player1.moving = ! player1.moving
		player2.moving = ! player2.moving
	player1.show_moving()
	player2.show_moving()
	
func who_gets_trick():
	if card2_played.overtakes(card1_played):
		return card2_played.loc + 2
	else:
		return card1_played.loc + 2		

