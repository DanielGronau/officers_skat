extends Control

const cols = [200, 400, 600, 800]
const rows = [1035, 165, 765, 435]

func _ready():
	initCards(Vector2(1400, 575))
	$Player1Container.add_child(Global.player1)
	$Player2Container.add_child(Global.player2)
	deal_backsides()

func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu/Menu.tscn")
	
func initCards(point: Vector2):
	for card in Global.cards:
		card.set_position(point)
		add_child(card)
		card.connect("card_clicked", self, "_on_card_clicked")
	
func deal_backsides():
	for i in 16:
		deal(i, false)
		yield(get_tree().create_timer(0.5), "timeout")
	deal_4_frontsides()

func deal_4_frontsides():
	for i in range(16, 20):
		deal(i, true)
		yield(get_tree().create_timer(0.5), "timeout")
	$Suits.visible = true	

func deal_rest_frontsides():
	for i in range(20, 32):
		deal(i, true)
		yield(get_tree().create_timer(0.5), "timeout")

func deal(i: int, open: bool):
		var x = (i % 16) % 4
		var y = (i % 16) / 4
		var c = Global.cards[i]
		if y % 2 == 0:
			c.loc = Global.Loc.PLAYER1
		else:
			c.loc = Global.Loc.PLAYER2
		if open:	
			c.z_index = 10
			c.flip()
			animate_card(c, Vector2(cols[x]+10, rows[y]+10), true)
			c.below = Global.cards[i-16]
		else:
			c.z_index = 9	
			animate_card(c, Vector2(cols[x], rows[y]), true)
		
func animate_card(card: Card, pos: Vector2, duration: float = 1.0):
	card.animate(pos, duration)
	
func _on_card_clicked(card: Card) -> void:
	if Global.trump != null && (card.loc == Global.Loc.PLAYER1 && Global.player1.moving) || (card.loc == Global.Loc.PLAYER2 && Global.player2.moving):
		if Global.card1_played == null:
			first_card_played(card)
		elif Global.card2_played == null && can_play(card):
			second_card_played(Global.card1_played, card)		
			
func first_card_played(card: Card) -> void:
	Global.card1_played = card
	Global.show_players(true)
	card.z_index = 100
	animate_card(card, Vector2(1400, 600), 0.3)
	card.z_index = 9
	var p2 = 0
	if card.loc == Global.Loc.PLAYER1:
		p2 = Global.Loc.PLAYER2
	else:
		p2 = Global.Loc.PLAYER1
	for c in Global.cards:
		if c.open && c.loc == p2 && !can_play(c):
			c.dark()	
	
func second_card_played(card1: Card, card2: Card) -> void:	
	for c in Global.cards:
		if c.open:
			c.bright()	
	Global.card2_played = card2
	card2.z_index = 100
	animate_card(card2, Vector2(1470, 700), 0.3)
	card2.z_index = 10
	yield(get_tree().create_timer(1), "timeout")
	if card1.below != null:
		card1.below.flip()
	if card2.below != null:
		card2.below.flip()
	var loc = Global.who_gets_trick()
	card2.loc = loc
	card1.loc = loc
	card1.flip()
	card2.flip()
	if (loc == Global.Loc.TRICK1):
		Global.player1.trick_points += card1.trick_value() + card2.trick_value()
		print(card1.say() + " " + card2.say() + " to Player1")
		animate_card(card1, Vector2(1550, 1035), 0.5)
		animate_card(card2, Vector2(1550, 1035), 0.5)
	else:	
		Global.player2.trick_points += card1.trick_value() + card2.trick_value()
		print(card1.say() + " " + card2.say() + " to Player2")
		animate_card(card1, Vector2(1550, 165), 0.5)
		animate_card(card2, Vector2(1550, 165), 0.5)
	Global.show_players((Global.player1.moving && loc == Global.Loc.TRICK2) 
		|| (Global.player2.moving && loc == Global.Loc.TRICK1))
	Global.card1_played = null	
	Global.card2_played = null
	check_game_end()
						
func can_play(card2: Node2D):
	var card1 = Global.card1_played
	if card1.is_trump():
		if card2.is_trump():
			return true # has trump and played it
		for c in Global.cards:
			if c.loc == card2.loc && c.open && c.is_trump():
				return false # has trump but didn't play it 
		return true	# can play any card	
	else:	
		if !card2.is_trump() && card1.suit == card2.suit:
			return true # has same suit and played it
		for c in Global.cards:
			if c.loc == card2.loc && c.open && !c.is_trump() && c.suit == card1.suit:
				return false # has same suite but didn't play it 
		return true # can play any card	
	
func check_game_end():
	pass
	
func _on_Acorn_pressed():
	if Global.trump == Global.Trump.NONE:
		trump_chosen(Global.Trump.ACORN)
		$Suits/Acorn.visible = true
		deal_rest_frontsides()

func _on_Leaves_pressed():
	if Global.trump == Global.Trump.NONE:
		trump_chosen(Global.Trump.LEAVES)
		$Suits/Leaves.visible = true
		deal_rest_frontsides()
		
func _on_Hearts_pressed():
	if Global.trump == Global.Trump.NONE:
		trump_chosen(Global.Trump.HEARTS)
		$Suits/Hearts.visible = true
		deal_rest_frontsides()

func _on_Bells_pressed():
	if Global.trump == Global.Trump.NONE:
		trump_chosen(Global.Trump.BELLS)
		$Suits/Bells.visible = true
		deal_rest_frontsides()

func _on_Grand_pressed():
	if Global.trump == Global.Trump.NONE:
		trump_chosen(Global.Trump.GRAND)
		$Suits/Grand.visible = true
		deal_rest_frontsides()
				
func trump_chosen(suit: int):
	Global.trump = suit
	$Suits/SuitLabel.text = "Trump Color"
	$Suits/Acorn.visible = false
	$Suits/Leaves.visible = false
	$Suits/Hearts.visible = false
	$Suits/Bells.visible = false
	$Suits/Grand.visible = false
