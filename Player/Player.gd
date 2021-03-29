extends Node2D

var player_name: String = "Player"
var type: int
var moving: bool

func _ready():
	$NameLabel.text = player_name
	show_moving()
	
func show_moving():
	if moving:
		$NameLabel.add_color_override("font_color", Color.white)
	else:
		$NameLabel.add_color_override("font_color", Color.darkgray)
		
