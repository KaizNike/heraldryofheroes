extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextEdit.grab_focus()
	$TextEdit.text = Data.get_node("Party").dict["notes"]
	$TextEdit.select_all()
	$TextEdit.set_caret_line($TextEdit.get_selection_to_line())
	$TextEdit.set_caret_column($TextEdit.get_selection_to_column())
	$TextEdit.deselect()

func _on_exit_pressed():
	save_and_close()

func save_and_close():
	Data.get_node("Party").dict["notes"] = $TextEdit.get_text()
	Main.overlay_scene("res://main/empty.tscn")
	queue_free()
	Main.pc_button_disable(0)



