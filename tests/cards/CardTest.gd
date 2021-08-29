extends GdUnitTestSuite

const Loc = preload("res://src/game/Loc.gd")
const Trump = preload("res://src/game/Trump.gd")
const Suit = preload("res://src/game/Suit.gd")
const Value = preload("res://src/game/Value.gd")
	
func test_card_is_trump():
	var scene = preload("res://src/cards/Card.tscn")
	var card = scene.instance()
	
	# Acorn 8 isn't trump if Leaves are played
	card.init(Suit.ACORN, Value.EIGHT, false)
	assert_bool(card.is_trump(Trump.LEAVES)).is_false()
	
	# Acorn Jack is trump if Leaves are played
	card.init(Suit.ACORN, Value.JACK, false)
	assert_bool(card.is_trump(Trump.LEAVES)).is_true()
	
	# Leaves 8 is trump if Leaves are played
	card.init(Suit.LEAVES, Value.EIGHT, false)
	assert_bool(card.is_trump(Trump.LEAVES)).is_true()
	
	# Leaves Jack is trump if Leaves are played
	card.init(Suit.LEAVES, Value.JACK, false)
	assert_bool(card.is_trump(Trump.LEAVES)).is_true()
	
	# Acorn 8 isn't trump if Grand is played
	card.init(Suit.ACORN, Value.EIGHT, false)
	assert_bool(card.is_trump(Trump.GRAND)).is_false()
	
	# Acorn Jack is trump if Grand is played
	card.init(Suit.ACORN, Value.JACK, false)
	assert_bool(card.is_trump(Trump.GRAND)).is_true()
	
	card.free()	
	scene.free()
	
func test_card_overtakes():
	var scene = preload("res://src/cards/Card.tscn")
	var card1 = scene.instance()
	var card2 = scene.instance()

	# Same suit, not trump
	card1.init(Suit.ACORN, Value.EIGHT, false)
	card2.init(Suit.ACORN, Value.TEN, false)	
	# Acorn 10 overtakes Acorn 8 (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_true
	# Acorn 10 overtakes Acorn 8 (Leaves is trump)
	assert_bool(card1.overtakes(card2, Trump.LEAVES)).is_false

	# Different suited, not trump	
	card1.init(Suit.ACORN, Value.EIGHT, false)
	card2.init(Suit.BELLS, Value.TEN, false)	
	# Bells 10 doesn't overtake Acorn 8 (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_false
	# Acorn 8 doesn't overtake Bells 10 (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_false

	# Same suit, trump	
	card1.init(Suit.LEAVES, Value.EIGHT, false)
	card2.init(Suit.LEAVES, Value.TEN, false)	
	# Leaves 10 overtakes Leaves 8 (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_true
	# Leaves 8 doesn't overtake Leaves 10 (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_false

	# Both trump, one Jack	
	card1.init(Suit.LEAVES, Value.TEN, false)	
	card2.init(Suit.BELLS, Value.JACK, false)
	# Bells Jack overtakes Leaves 10 (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_true
	# Leaves 10 doesn't overtake Bells Jack (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_false
		
	# Two Jacks
	card1.init(Suit.BELLS, Value.JACK, false)	
	card2.init(Suit.HEARTS, Value.JACK, false)
	# Hearts Jack overtakes Bells Jack (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_true
	# Bells Jack doesn't overtake Hearts Jack (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_false

	card1.init(Suit.LEAVES, Value.JACK, false)	
	card2.init(Suit.ACORN, Value.JACK, false)
	# Acorn Jack overtakes Leaves Jack (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_true
	# Leaves Jack doesn't overtake Acorn Jack (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_false

	# Non-trump and trump
	card1.init(Suit.ACORN, Value.ACE, false)
	card2.init(Suit.LEAVES, Value.EIGHT, false)
	# Leaves 8 overtakes Acorn Ace (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_true
	# Acorn Ace doesn't overtake Leaves 8 (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_false
	
	# Non-trump and Jack
	card1.init(Suit.ACORN, Value.ACE, false)
	card2.init(Suit.BELLS, Value.JACK, false)
	# Bells Jack overtakes Acorn Ace (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_true
	# Acorn Ace doesn't overtake Bells Jack (Leaves is trump)
	assert_bool(card2.overtakes(card1, Trump.LEAVES)).is_false
		
	card1.free()
	card2.free()
	scene.free()
	
func test_card_order_value():
	var scene = preload("res://src/cards/Card.tscn")
	var card = scene.instance()
	card.init(Suit.ACORN, Value.SEVEN, false)
	assert_int(card.order_value()).is_equal(0)
	card.init(Suit.ACORN, Value.EIGHT, false)
	assert_int(card.order_value()).is_equal(1)
	card.init(Suit.ACORN, Value.NINE, false)
	assert_int(card.order_value()).is_equal(2)
	card.init(Suit.ACORN, Value.TEN, false)
	assert_int(card.order_value()).is_equal(7)
	card.init(Suit.ACORN, Value.JACK, false)
	assert_int(card.order_value()).is_equal(20)
	card.init(Suit.LEAVES, Value.JACK, false)
	assert_int(card.order_value()).is_equal(19)
	card.init(Suit.HEARTS, Value.JACK, false)
	assert_int(card.order_value()).is_equal(18)
	card.init(Suit.BELLS, Value.JACK, false)
	assert_int(card.order_value()).is_equal(17)
	card.init(Suit.ACORN, Value.QUEEN, false)
	assert_int(card.order_value()).is_equal(5)
	card.init(Suit.ACORN, Value.KING, false)
	assert_int(card.order_value()).is_equal(6)
	card.init(Suit.ACORN, Value.ACE, false)
	assert_int(card.order_value()).is_equal(8)
		
	card.free()	
	scene.free()	
	
