extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextEdit.grab_focus()
	var notes = Data.load_game("user://notes.save")
	$TextEdit.text = notes["notes"]
	$TextEdit.select_all()
	$TextEdit.set_caret_line($TextEdit.get_selection_to_line())
	$TextEdit.set_caret_column($TextEdit.get_selection_to_column())
	$TextEdit.deselect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if Input.is_key_pressed(KEY_ESCAPE):
		#Data.save_notes($TextEdit.get_text())
		#Main.overlay_scene("res://main/Empty.tscn")
		#queue_free()

#handling keyboard input
func _unhandled_key_input(event):
	if event is InputEventKey and event.is_pressed():
		get_viewport().set_input_as_handled()
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_F1:
			save_and_close()

func save_and_close():
	Data.save_notes($TextEdit.get_text())
	Main.overlay_scene("res://main/Empty.tscn")
	queue_free()
	Main.pc_button_disable(0)
