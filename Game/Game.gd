extends Control

const cols = [200, 400, 600, 800]
const rows = [1035, 165, 765, 435]

func _ready():
	prepareCards(Vector2(1400, 575))
	$Player1Container.add_child(Global.player1)
	$Player2Container.add_child(Global.player2)
	deal_backsides()

func _on_BackButton_pressed():
	get_tree().change_scene("res://Menu/Menu.tscn")
	
func prepareCards(point: Vector2):
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
			deal_card(c, Vector2(cols[x]+10, rows[y]+10), true)
			c.below = Global.cards[i-16]
		else:
			deal_card(c, Vector2(cols[x], rows[y]), false)
		
func deal_card(card: Node, pos: Vector2, open: bool):
	if open:
		card.z_index = 10
	else:
		card.z_index = 9	
	if card.open != open:
			card.flip()
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, card.name + ":position")
	animation.track_insert_key(track_index, 0.0, card.position)
	animation.track_insert_key(track_index, 1, pos)
	track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, card.name + ":rotation_degrees")
	animation.track_insert_key(track_index, 0.0, 0)
	animation.track_insert_key(track_index, 1, 360)
	var player = AnimationPlayer.new()
	add_child(player)
	player.add_animation(card.name, animation)
	player.play(card.name)
	yield(player, "animation_finished")
	remove_child(player)
	player.queue_free()
	
func _on_card_clicked(card: Card):
	if (card.loc == Global.Loc.PLAYER1 && Global.player1.moving) || (card.loc == Global.Loc.PLAYER2 && Global.player2.moving):
		if Global.card1_played == null:
			Global.card1_played = card
			Global.show_players(true)
			card.position = Vector2(1400, 600)
			card.z_index = 9
		elif Global.card2_played == null && can_play(card):		
			Global.card2_played = card
			card.position = Vector2(1470, 700)
			card.z_index = 10
			yield(get_tree().create_timer(1), "timeout")
			var loc = Global.who_gets_trick()
			card.loc = loc
			Global.card1_played.loc = loc
			if (loc == Global.Loc.TRICK1):
				Global.player1.trick_points += card.trick_value() + Global.card1_played.trick_value()
				print(Global.card1_played.say() + " " + card.say() + " to Player1")
			else:	
				Global.player2.trick_points += card.trick_value() + Global.card1_played.trick_value()
				print(Global.card1_played.say() + " " + card.say() + " to Player2")
			Global.show_players((Global.player1.moving && loc == Global.Loc.TRICK2) 
				|| (Global.player2.moving && loc == Global.Loc.TRICK1))
			card.visible = false
			Global.card1_played.visible = false
			if card.below != null:
				card.below.flip()
			if Global.card1_played.below != null:
				Global.card1_played.below.flip()
			Global.card1_played = null	
			Global.card2_played = null
			check_game_end()	
						
func can_play(card: Node2D):
	return true			
	
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
