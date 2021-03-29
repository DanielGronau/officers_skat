extends Sprite

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		if get_parent().open && get_rect().has_point(get_local_mouse_position()):
			get_parent().clicked()
