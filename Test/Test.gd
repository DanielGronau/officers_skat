extends Control


func _ready():
	card_isTrump()
	card_overtakes()
	card_order_value()
	print("testing ready")
	
func card_isTrump():
	var scene = preload("res://Cards/Card.tscn")
	var card = scene.instance()
	Global.trump = Global.Trump.LEAVES	
	card.init(Global.Suit.ACORN, Global.Value.EIGHT, false)
	if (card.is_trump()):
		push_error(card.say() + " shouldn't be considered trump (Leaves is trump)")
	card.init(Global.Suit.ACORN, Global.Value.JACK, false)
	if (!card.is_trump()):
		push_error(card.say() + " should be considered trump (Leaves is trump)")
	card.init(Global.Suit.LEAVES, Global.Value.JACK, false)
	if (!card.is_trump()):
		push_error(card.say() + " shouldn't be considered trump (Leaves is trump)")
	Global.trump = Global.Trump.GRAND
	card.init(Global.Suit.ACORN, Global.Value.EIGHT, false)
	if (card.is_trump()):
		push_error(card.say() + " shouldn't be considered trump (Grand is trump)")
	card.init(Global.Suit.ACORN, Global.Value.JACK, false)
	if (!card.is_trump()):
		push_error(card.say() + " should be considered trump (Grand is trump)")
	
func card_overtakes():
	var scene = preload("res://Cards/Card.tscn")
	var card1 = scene.instance()
	var card2 = scene.instance()
	Global.trump = Global.Trump.LEAVES	
	# same suit, not trump
	card1.init(Global.Suit.ACORN, Global.Value.EIGHT, false)
	card2.init(Global.Suit.ACORN, Global.Value.TEN, false)	
	if (! card2.overtakes(card1)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# different suits, not trump	
	card1.init(Global.Suit.ACORN, Global.Value.EIGHT, false)
	card2.init(Global.Suit.BELLS, Global.Value.TEN, false)	
	if (card2.overtakes(card1)):
		push_error(card2.say() + " shouldn't overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# same suit, trump	
	card1.init(Global.Suit.LEAVES, Global.Value.EIGHT, false)
	card2.init(Global.Suit.LEAVES, Global.Value.TEN, false)	
	if (!card2.overtakes(card1)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# both trump, one Jack	
	card1.init(Global.Suit.LEAVES, Global.Value.TEN, false)	
	card2.init(Global.Suit.BELLS, Global.Value.JACK, false)
	if (!card2.overtakes(card1)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# two Jacks
	card1.init(Global.Suit.BELLS, Global.Value.JACK, false)	
	card2.init(Global.Suit.HEARTS, Global.Value.JACK, false)
	if (!card2.overtakes(card1)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	card1.init(Global.Suit.LEAVES, Global.Value.JACK, false)	
	card2.init(Global.Suit.ACORN, Global.Value.JACK, false)
	if (!card2.overtakes(card1)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# non-trump and trump
	card1.init(Global.Suit.ACORN, Global.Value.ACE, false)
	card2.init(Global.Suit.LEAVES, Global.Value.EIGHT, false)
	if (!card2.overtakes(card1)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# non-trump and Jack
	card1.init(Global.Suit.ACORN, Global.Value.ACE, false)
	card2.init(Global.Suit.BELLS, Global.Value.JACK, false)
	if (!card2.overtakes(card1)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	
func card_order_value():
	var scene = preload("res://Cards/Card.tscn")
	var card = scene.instance()
	card.init(Global.Suit.ACORN, Global.Value.SEVEN, false)
	if (card.order_value() != 0):
		push_error(card.say() + " should have order value 0, not " + str(card.order_value()))
	card.init(Global.Suit.ACORN, Global.Value.EIGHT, false)
	if (card.order_value() != 1):
		push_error(card.say() + " should have order value 1, not " + str(card.order_value()))
	card.init(Global.Suit.ACORN, Global.Value.NINE, false)
	if (card.order_value() != 2):
		push_error(card.say() + " should have order value 2, not " + str(card.order_value()))
	card.init(Global.Suit.ACORN, Global.Value.TEN, false)
	if (card.order_value() != 7):
		push_error(card.say() + " should have order value 7, not " + str(card.order_value()))
	card.init(Global.Suit.ACORN, Global.Value.JACK, false)
	if (card.order_value() != 20):
		push_error(card.say() + " should have order value 20, not " + str(card.order_value()))
	card.init(Global.Suit.LEAVES, Global.Value.JACK, false)
	if (card.order_value() != 19):
		push_error(card.say() + " should have order value 19, not " + str(card.order_value()))
	card.init(Global.Suit.HEARTS, Global.Value.JACK, false)
	if (card.order_value() != 18):
		push_error(card.say() + " should have order value 18, not " + str(card.order_value()))
	card.init(Global.Suit.BELLS, Global.Value.JACK, false)
	if (card.order_value() != 17):
		push_error(card.say() + " should have order value 17, not " + str(card.order_value()))
	card.init(Global.Suit.ACORN, Global.Value.QUEEN, false)
	if (card.order_value() != 5):
		push_error(card.say() + " should have order value 5, not " + str(card.order_value()))
	card.init(Global.Suit.ACORN, Global.Value.KING, false)
	if (card.order_value() != 6):
		push_error(card.say() + " should have order value 6, not " + str(card.order_value()))
	card.init(Global.Suit.ACORN, Global.Value.ACE, false)
	if (card.order_value() != 8):
		push_error(card.say() + " should have order value 8, not " + str(card.order_value()))
	
	
