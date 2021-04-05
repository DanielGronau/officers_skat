extends Node2D

class_name Player

var player_name: String = "Player"
var type: int
var moving: bool
var trick_points: int = 0

func _ready():
	show_moving()
	
func show_moving():
	$NameLabel.text = player_name + " (" + str(trick_points) + ")"
	if moving:
		$NameLabel.add_color_override("font_color", Color.white)
	else:
		$NameLabel.add_color_override("font_color", Color.darkgray)
		
