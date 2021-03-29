extends Node2D

signal card_clicked(card)

enum Loc {HEAP, PLAYER1, PLAYER2, TRICK1, TRICK2}

var suit: int = 0
var value: int = 0
var open: bool = false
var loc = Loc.HEAP

func _ready():
	init(0,0,false)

func init(_suit: int, _value: int, _open: bool):
	suit = _suit
	value = _value
	open = _open
	if open: 
		$Sprite.set_texture(load("res://Cards/row-" + str(suit + 1) + "-col-" + str(value + 1) + ".png"))
	else:
		$Sprite.set_texture(load("res://Cards/cardback.png"))

func flip():
	init(suit, value, ! open) 
	
func clicked():
	emit_signal("card_clicked", self)	
