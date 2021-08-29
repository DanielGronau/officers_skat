extends WindowDialog

signal trump_selected(trump)

const Trump = preload("res://src/game/Trump.gd")

func _ready():
	pass
	
func selected(trump: int):
	emit_signal("trump_selected", trump)
	visible = false
	
func _on_Acorn_pressed():
	selected(Trump.ACORN)

func _on_Leaves_pressed():
	selected(Trump.LEAVES)

func _on_Hearts_pressed():
	selected(Trump.HEARTS)

func _on_Bells_pressed():
	selected(Trump.BELLS)

func _on_Grand_pressed():
	selected(Trump.GRAND)
