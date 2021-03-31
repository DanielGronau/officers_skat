extends Node2D

class_name Card

signal card_clicked(card)

var suit: int = 0
var value: int = 0
var open: bool = false
var loc = Global.Loc.HEAP
var below: Card = null

const suit2row = {
	0: 4,
	1: 3,
	2: 1,
	3: 2 
}

func _ready():
	pass

func init(_suit: int, _value: int, _open: bool):
	suit = _suit
	value = _value
	open = _open
	$Front.set_texture(load("res://Cards/row-" + str(suit2row[_suit]) + "-col-" + str(value + 1) + ".png"))
	if (open) :
		flip()

func flip():
	open = ! open
	$Front.visible = open
	$Back.visible = ! open
	
func clicked():
	emit_signal("card_clicked", self)
	
func is_trump():
	return value == Global.Value.JACK || suit == Global.trump
