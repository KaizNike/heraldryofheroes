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

func save_and_close():
	Data.save_notes($TextEdit.get_text())
	Main.overlay_scene("res://main/Empty.tscn")
	queue_free()
	Main.pc_button_disable(0)
