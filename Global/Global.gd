extends Node

enum Trump {NONE, ACORN, LEAVES, HEARTS, BELLS, GRAND}
enum PlayerType { HUMAN, WEAK_AI, MEDIUM_AI, STRONG_AI }

var player1: Node2D
var player2: Node2D

var trump: int = Trump.NONE

func _ready():
	pass
	
func clear(_starter: int):
	trump = Trump.NONE
	
