extends Node2D

class_name Card

signal card_clicked(card)

var suit: int = 0
var value: int = 0
var open: bool = false
var loc = Global.Loc.HEAP
var below: Card = null

const suit2row = [4, 3, 1, 2]
const val2trick = [0, 0, 0, 10, 2, 3, 4, 11]
const suit2say = ["Acorn", "Leaves", "Hearts", "Bells"]
const val2say = ["7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]

func _ready():
	pass

func init(_suit: int, _value: int, _open: bool) -> void:
	suit = _suit
	value = _value
	open = _open
	$Front.set_texture(load("res://Cards/row-" + str(suit2row[_suit]) + "-col-" + str(value + 1) + ".png"))
	if (open) :
		flip()

func flip() -> void:
	open = ! open
	$Front.visible = open
	$Back.visible = ! open
	
func clicked() -> void:
	emit_signal("card_clicked", self)
	
func is_trump() -> bool:
	return value == Global.Value.JACK || suit == Global.trump
	
func overtakes(card: Card) -> bool:
	if card.is_trump() && ! is_trump(): # throw away on a trump
		return false
	elif ! card.is_trump() && is_trump(): # made the trick with a trump
		return true
	elif suit != card.suit: # throw away on non-trump
		return false	
	else: # same suit or trump
		return order_value() > card.order_value()
	
func order_value() -> int:
	if value == Global.Value.JACK:
		return 20 - suit # ACORN-JACK = 20 ... BELLS-JACK = 17
	elif value == Global.Value.TEN:
		return 7	
	elif value == Global.Value.ACE:
		return 8	
	else:
		return value
		
func trick_value() -> int:
	return val2trick[value]
	
func say() -> String:
	return val2say[value] + " of " + suit2say[suit]				

