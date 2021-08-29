extends Control

const Loc = preload("res://src/game/Loc.gd")
const Trump = preload("res://src/game/Trump.gd")
const Suit = preload("res://src/game/Suit.gd")
const Value = preload("res://src/game/Value.gd")
const State = preload("res://src/game/State.gd")
const PlayerType = preload("res://src/game/PlayerType.gd")

const cols = [200, 400, 600, 800]
const rows = [1035, 165, 765, 435]

var player1: Player
var player2: Player
var cards: Array = Array()
var card1_played: Card = null
var card2_played: Card = null
var game_started_by: int = 1
var trump: int = Trump.NONE
var state: int = State.CHOOSE_TRUMP

func _ready():
	createCards()
	var scene = preload("res://src/player/Player.tscn")
	player1 = scene.instance()
	player1.player_name = "Player 1"
	player1.type = PlayerType.HUMAN
	player1.moving = true
	player2 = scene.instance()
	player2.player_name = "Player 2"
	player2.type = PlayerType.HUMAN
	player2.moving = false
	initCards(Vector2(1400, 575))
	$Player1Container.add_child(player1)
	$Player2Container.add_child(player2)
	deal_backsides()
	
func createCards():
	var scene = preload("res://src/cards/Card.tscn")
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
	if card2_played.overtakes(card1_played, trump):
		return card2_played.loc + 2
	else:
		return card1_played.loc + 2	

func _on_BackButton_pressed():
	get_tree().change_scene("res://src/menu/Menu.tscn")
	
func initCards(point: Vector2):
	for card in cards:
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
	$Canvas/TrumpDialog.popup_centered()

func deal_rest_frontsides():
	for i in range(20, 32):
		deal(i, true)
		yield(get_tree().create_timer(0.5), "timeout")
	state = State.FIRST_CARD	

func deal(i: int, open: bool):
		var x = (i % 16) % 4
		var y = (i % 16) / 4
		var c = cards[i]
		if y % 2 == 0:
			c.loc = Loc.PLAYER1
		else:
			c.loc = Loc.PLAYER2
		if open:	
			c.z_index = 10
			c.flip()
			animate_card(c, Vector2(cols[x]+10, rows[y]+10), true)
			c.below = cards[i-16]
		else:
			c.z_index = 9	
			animate_card(c, Vector2(cols[x], rows[y]), true)
		
func animate_card(card: Card, pos: Vector2, duration: float = 1.0):
	card.animate(pos, duration)
	
func _on_card_clicked(card: Card) -> void:
	if trump != null && (card.loc == Loc.PLAYER1 && player1.moving) || (card.loc == Loc.PLAYER2 && player2.moving):
		if state == State.FIRST_CARD:
			first_card_played(card)
		elif state == State.SECOND_CARD && can_play(card):
			second_card_played(card1_played, card)		
			
func first_card_played(card: Card) -> void:
	card1_played = card
	show_players(true)
	card.z_index = 100
	animate_card(card, Vector2(1400, 600), 0.3)
	card.z_index = 9
	var p2 = 0
	if card.loc == Loc.PLAYER1:
		p2 = Loc.PLAYER2
	else:
		p2 = Loc.PLAYER1
	for c in cards:
		if c.open && c.loc == p2 && !can_play(c):
			c.dark()
	state = State.SECOND_CARD			
	
func second_card_played(card1: Card, card2: Card) -> void:	
	for c in cards:
		if c.open:
			c.bright()	
	card2_played = card2
	card2.z_index = 100
	animate_card(card2, Vector2(1470, 700), 0.3)
	card2.z_index = 10
	yield(get_tree().create_timer(1), "timeout")
	if card1.below != null:
		card1.below.flip()
	if card2.below != null:
		card2.below.flip()
	var loc = who_gets_trick()
	card2.loc = loc
	card1.loc = loc
	card1.flip()
	card2.flip()
	if (loc == Loc.TRICK1):
		player1.trick_points += card1.trick_value() + card2.trick_value()
		print(card1.say() + " " + card2.say() + " to Player1")
		animate_card(card1, Vector2(1550, 1035), 0.5)
		animate_card(card2, Vector2(1550, 1035), 0.5)
	else:	
		player2.trick_points += card1.trick_value() + card2.trick_value()
		print(card1.say() + " " + card2.say() + " to Player2")
		animate_card(card1, Vector2(1550, 165), 0.5)
		animate_card(card2, Vector2(1550, 165), 0.5)
	show_players((player1.moving && loc == Loc.TRICK2) 
		|| (player2.moving && loc == Loc.TRICK1))
	card1_played = null	
	card2_played = null
	state = State.FIRST_CARD	
	check_game_end()
						
func can_play(card2: Node2D):
	var card1 = card1_played
	if card1.is_trump(trump):
		if card2.is_trump(trump):
			return true # has trump and played it
		for c in cards:
			if c.loc == card2.loc && c.open && c.is_trump(trump):
				return false # has trump but didn't play it 
		return true	# can play any card	
	else:	
		if !card2.is_trump(trump) && card1.suit == card2.suit:
			return true # has same suit and played it
		for c in cards:
			if c.loc == card2.loc && c.open && !c.is_trump(trump) && c.suit == card1.suit:
				return false # has same suite but didn't play it 
		return true # can play any card	
	
func check_game_end():
	pass
	
func _on_trump_selected(suit: int):
	trump = suit
	state = State.DEAL_REMAINING
	$Canvas/TrumpLabel.text = Trump.as_string(trump)
	deal_rest_frontsides()
	
	
