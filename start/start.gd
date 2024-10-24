extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Menu/Continue.grab_focus()
	Main.party_count = 0
	Data.get_node("PC1").clear_dict()
	Main.pc1.visible = false
	Data.get_node("PC2").clear_dict()
	Main.pc2.visible = false
	Data.get_node("PC3").clear_dict()
	Main.pc3.visible = false
	Data.get_node("PC4").clear_dict()
	Main.pc4.visible = false
	Data.get_node("PC5").clear_dict()
	Main.pc5.visible = false

# buttons
func _on_continue_button_down():
	load_game("user://one.save")
	Main.update_boxes()
	Main.goto_scene(Data.get_node("Party").dict["location"])
	queue_free()

func _on_new_game_button_down():
	Data.minute = 600
	Data.time["hour"] = 8
	Data.time["day"] = 28
	Data.time["month"] = 2
	Data.time["year"] = 1400
	Data.save_game()
	
	Data.settings["music_volume"] = -80
	Data.settings["sfx_volume"] = -80
	Main.update_boxes()
	Main.goto_scene("res://start/choose_heraldry.tscn")
	queue_free()

#captures keyboard input, prevents player pressing escape key to open up 'in-game' menu
func _unhandled_key_input(_event):
	get_viewport().set_input_as_handled()
	
func load_game(file):
	Data.load_game(file)
	
	if Data.get_node("PC1").dict["first_name"] == null:
		Main.pc_button_disable(1)
		Main.pc1.visible = false
		
	if Data.get_node("PC2").dict["first_name"] == null:
		Main.pc_button_disable(2)
		Main.pc2.visible = false
	
	if Data.get_node("PC3").dict["first_name"] == null:
		Main.pc_button_disable(3)
		Main.pc3.visible = false
	
	if Data.get_node("PC4").dict["first_name"] == null:
		Main.pc_button_disable(4)
		Main.pc4.visible = false
	
	if Data.get_node("PC5").dict["first_name"] == null:
		Main.pc_button_disable(5)
		Main.pc5.visible = false
	
	Main.get_node("Audio/Music").volume_db = Data.settings["music_volume"]
	Main.get_node("Audio/SFX").volume_db = Data.settings["sfx_volume"]
	
	var anim: Animation = Main.get_node("Audio/SFX/Player").get_animation("fade_in")
	var key_id: int = anim.track_find_key(0, 1)
	anim.track_set_key_value(0, key_id, Data.settings["sfx_volume"])
	
	anim = Main.get_node("Audio/SFX/Player").get_animation("fade_out")
	key_id = anim.track_find_key(0, 0)
	anim.track_set_key_value(0, key_id, Data.settings["sfx_volume"])
	key_id = anim.track_find_key(0, 1)
	anim.track_set_key_value(0, key_id, Data.settings["sfx_volume"] * 3/4)
	
