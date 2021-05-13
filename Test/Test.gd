extends Control

const Loc = preload("res://Game/Loc.gd")
const Trump = preload("res://Game/Trump.gd")
const Suit = preload("res://Game/Suit.gd")
const Value = preload("res://Game/Value.gd")

func _ready():
	card_isTrump()
	card_overtakes()
	card_order_value()
	print("testing ready")
	
func card_isTrump():
	var scene = preload("res://Cards/Card.tscn")
	var card = scene.instance()
	card.init(Suit.ACORN, Value.EIGHT, false)
	if (card.is_trump(Trump.LEAVES)):
		push_error(card.say() + " shouldn't be considered trump (Leaves is trump)")
	card.init(Suit.ACORN, Value.JACK, false)
	if (!card.is_trump(Trump.LEAVES)):
		push_error(card.say() + " should be considered trump (Leaves is trump)")
	card.init(Suit.LEAVES, Value.JACK, false)
	if (!card.is_trump(Trump.LEAVES)):
		push_error(card.say() + " shouldn't be considered trump (Leaves is trump)")
	card.init(Suit.ACORN, Value.EIGHT, false)
	if (card.is_trump(Trump.GRAND)):
		push_error(card.say() + " shouldn't be considered trump (Grand is trump)")
	card.init(Suit.ACORN, Value.JACK, false)
	if (!card.is_trump(Trump.GRAND)):
		push_error(card.say() + " should be considered trump (Grand is trump)")
	
func card_overtakes():
	var scene = preload("res://Cards/Card.tscn")
	var card1 = scene.instance()
	var card2 = scene.instance()
	# same suit, not trump
	card1.init(Suit.ACORN, Value.EIGHT, false)
	card2.init(Suit.ACORN, Value.TEN, false)	
	if (! card2.overtakes(card1, Trump.LEAVES)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2, Trump.LEAVES)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# different suits, not trump	
	card1.init(Suit.ACORN, Value.EIGHT, false)
	card2.init(Suit.BELLS, Value.TEN, false)	
	if (card2.overtakes(card1, Trump.LEAVES)):
		push_error(card2.say() + " shouldn't overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2, Trump.LEAVES)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# same suit, trump	
	card1.init(Suit.LEAVES, Value.EIGHT, false)
	card2.init(Suit.LEAVES, Value.TEN, false)	
	if (!card2.overtakes(card1, Trump.LEAVES)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2, Trump.LEAVES)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# both trump, one Jack	
	card1.init(Suit.LEAVES, Value.TEN, false)	
	card2.init(Suit.BELLS, Value.JACK, false)
	if (!card2.overtakes(card1, Trump.LEAVES)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2, Trump.LEAVES)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# two Jacks
	card1.init(Suit.BELLS, Value.JACK, false)	
	card2.init(Suit.HEARTS, Value.JACK, false)
	if (!card2.overtakes(card1, Trump.LEAVES)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2, Trump.LEAVES)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	card1.init(Suit.LEAVES, Value.JACK, false)	
	card2.init(Suit.ACORN, Value.JACK, false)
	if (!card2.overtakes(card1, Trump.LEAVES)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2, Trump.LEAVES)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# non-trump and trump
	card1.init(Suit.ACORN, Value.ACE, false)
	card2.init(Suit.LEAVES, Value.EIGHT, false)
	if (!card2.overtakes(card1, Trump.LEAVES)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2, Trump.LEAVES)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	# non-trump and Jack
	card1.init(Suit.ACORN, Value.ACE, false)
	card2.init(Suit.BELLS, Value.JACK, false)
	if (!card2.overtakes(card1, Trump.LEAVES)):
		push_error(card2.say() + " should overtake " + card1.say() + " (Leaves is trump)")	
	if (card1.overtakes(card2, Trump.LEAVES)):
		push_error(card1.say() + " shouldn't overtake " + card2.say() + " (Leaves is trump)")	
	
func card_order_value():
	var scene = preload("res://Cards/Card.tscn")
	var card = scene.instance()
	card.init(Suit.ACORN, Value.SEVEN, false)
	if (card.order_value() != 0):
		push_error(card.say() + " should have order value 0, not " + str(card.order_value()))
	card.init(Suit.ACORN, Value.EIGHT, false)
	if (card.order_value() != 1):
		push_error(card.say() + " should have order value 1, not " + str(card.order_value()))
	card.init(Suit.ACORN, Value.NINE, false)
	if (card.order_value() != 2):
		push_error(card.say() + " should have order value 2, not " + str(card.order_value()))
	card.init(Suit.ACORN, Value.TEN, false)
	if (card.order_value() != 7):
		push_error(card.say() + " should have order value 7, not " + str(card.order_value()))
	card.init(Suit.ACORN, Value.JACK, false)
	if (card.order_value() != 20):
		push_error(card.say() + " should have order value 20, not " + str(card.order_value()))
	card.init(Suit.LEAVES, Value.JACK, false)
	if (card.order_value() != 19):
		push_error(card.say() + " should have order value 19, not " + str(card.order_value()))
	card.init(Suit.HEARTS, Value.JACK, false)
	if (card.order_value() != 18):
		push_error(card.say() + " should have order value 18, not " + str(card.order_value()))
	card.init(Suit.BELLS, Value.JACK, false)
	if (card.order_value() != 17):
		push_error(card.say() + " should have order value 17, not " + str(card.order_value()))
	card.init(Suit.ACORN, Value.QUEEN, false)
	if (card.order_value() != 5):
		push_error(card.say() + " should have order value 5, not " + str(card.order_value()))
	card.init(Suit.ACORN, Value.KING, false)
	if (card.order_value() != 6):
		push_error(card.say() + " should have order value 6, not " + str(card.order_value()))
	card.init(Suit.ACORN, Value.ACE, false)
	if (card.order_value() != 8):
		push_error(card.say() + " should have order value 8, not " + str(card.order_value()))
	
	
