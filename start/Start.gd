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
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")
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
		Main.pc1.visible = false
		
	Data.get_node("PC2").dict = Data.load_game("user://pc2.save")
	if Data.get_node("PC2").dict["first_name"] == null:
		Main.pc_button_disable(2)
		Main.pc2.visible = false
	
	Data.get_node("PC3").dict = Data.load_game("user://pc3.save")
	if Data.get_node("PC3").dict["first_name"] == null:
		Main.pc_button_disable(3)
		Main.pc3.visible = false
	
	Data.get_node("PC4").dict = Data.load_game("user://pc4.save")
	if Data.get_node("PC4").dict["first_name"] == null:
		Main.pc_button_disable(4)
		Main.pc4.visible = false
	
	Data.get_node("PC5").dict = Data.load_game("user://pc5.save")
	if Data.get_node("PC5").dict["first_name"] == null:
		Main.pc_button_disable(5)
		Main.pc5.visible = false
	
	Data.inventory = Data.load_game("user://inventory.save")
	Data.stats = Data.load_game("user://stats.save")
	Data.time = Data.load_game("user://time.save")
	Data.hour = Data.time["hour"]
	
func new_game():
	Data.stats["money"] = 100
	
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
	
	Data.save_game()
	Data.save_notes("")
