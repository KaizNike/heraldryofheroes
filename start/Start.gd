extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	#disabled unused pc5 so it can't be seen or clicked, which would cause an error
	Main.pc_button_disable(5)
	
func _on_continue_button_down():
	load_game()
	Main.update_boxes()
	Main.goto_scene("res://scenarios/" + Data.stats["location"] + ".tscn")
	queue_free()

func _on_new_game_button_down():
	new_game()
	Main.update_boxes()
	Main.goto_scene("res://scenarios/leipzig/inn/Inn.tscn")
	queue_free()

func _on_combat_button_down():
	load_game()
	Main.update_boxes()
	Main.goto_scene("res://combat/Combat.tscn")
	queue_free()

func load_game():

	Data.get_node("PC1").dict = Data.load_game("user://pc1.save")
	if Data.get_node("PC1").dict["first_name"] == null:
		Main.pc_button_disable(1)
		Main.pc_button_hide("HBox/Party/PC1Frame/PC1")
		
	Data.get_node("PC2").dict = Data.load_game("user://pc2.save")
	if Data.get_node("PC2").dict["first_name"] == null:
		Main.pc_button_disable(2)
		Main.pc_button_hide("HBox/Party/PC2Frame/PC2")
	
	Data.get_node("PC3").dict = Data.load_game("user://pc3.save")
	if Data.get_node("PC3").dict["first_name"] == null:
		Main.pc_button_disable(3)
		Main.pc_button_hide("HBox/Party/PC3Frame/PC3")
	
	Data.get_node("PC4").dict = Data.load_game("user://pc4.save")
	if Data.get_node("PC4").dict["first_name"] == null:
		Main.pc_button_disable(4)
		Main.pc_button_hide("HBox/Party/PC4Frame/PC4")
	
	Data.inventory = Data.load_game("user://inventory.save")
	Data.stats = Data.load_game("user://stats.save")
	Data.time_dict = Data.load_game("user://time.save")
	Data.time = Data.time_dict["hour"]
	
func new_game():
	Data.stats["money"] = 100
	Data.stats["year"] = 1400
	
	Data.new_player("PC1")
	Data.new_player("PC2")
	Data.new_player("PC3")
	Data.new_player("PC4")
	
	Data.save_game()
	Data.save_notes("")
