extends Control

func _ready():
	pass 

func _on_Play_pressed():
	var scene = preload("res://src/player/Player.tscn")
	
	var p1 = scene.instance()
	p1.player_name = "Player 1"
	p1.type = Global.PlayerType.HUMAN
	p1.moving = true
	Global.player1 = p1

	var p2 = scene.instance()
	p2.player_name = "Player 2"
	p2.type = Global.PlayerType.HUMAN
	p2.moving = false
	Global.player2 = p2
	
	get_tree().change_scene("res://src/game/Game.tscn")
	
