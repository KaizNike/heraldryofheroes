extends MarginContainer

# Shortcut for the frame node where scenarios and player stats are displayed
@onready var frame = get_node("HBox/Frame")
@onready var pc1 = get_node("HBox/Party/PC1Frame/PC1")
@onready var pc2 = get_node("HBox/Party/PC2Frame/PC2")
@onready var pc3 = get_node("HBox/Party/PC3Frame/PC3")
@onready var pc4 = get_node("HBox/Party/PC4Frame/PC4")
@onready var pc5 = get_node("HBox/Party/PC5Frame/PC5")

var current_scene = null #the current scenario displayed in the large gold frame
var over_scene = null #used for overlaying the pc_sheet and notes_sheet over the top of a scenario
var is_scene_overlayed = false #keep track of whether or not a scene is overlayed, such as the notes sheet
var return_scene = null #used when a common scenario like pc_create needs to return to where it was called

var music_select = 1 #music tracks are given a number, which the audiostream plays in sequence
var party_count = 0 #the number of people in the party

signal ui_update

func _ready():
	current_scene = frame.get_child(0)
	over_scene = frame.get_child(1)
	$Audio/Music.stream = load("res://audio/music/" + str(music_select) + ".ogg")
	$Audio/Music.playing = true
	$Audio/Music.volume_db = -80
	$Audio/SFX.volume_db = -80

func goto_scene(path):
	Data.minute += 15 #default time passing for each scene change
	#check if the scene being called is a return_scene
	if path == "return_scene":
		path = return_scene
	#defer the load to a later time, when sure no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()
	# Load the new scene.
	var s = ResourceLoader.load(path)
	# Instance the new scene.
	current_scene = s.instantiate()
	# Add it to the active scene, as child of ScenarioFrame.
	frame.add_child(current_scene)
	pc_button_disable(0)

# used to overlay player/notes sheets on top of the current scene
# so able to switch back to the current scene after
func overlay_scene(path):
	call_deferred("_deferred_overlay_scene", path)

func _deferred_overlay_scene(path):
	if path == "res://main/Empty.tscn":
		is_scene_overlayed = false
	else:
		is_scene_overlayed = true
	over_scene.free()
	var s = ResourceLoader.load(path)
	# Instance the new scene.
	over_scene = s.instantiate()
	# Add it to the active scene, as child of ScenarioFrame.
	frame.add_child(over_scene)

func _unhandled_key_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F1 and pc1.visible:
			show_pc_sheet(1)
		elif event.keycode == KEY_F2 and pc2.visible:
			show_pc_sheet(2)
		elif event.keycode == KEY_F3 and pc3.visible:
			show_pc_sheet(3)
		elif event.keycode == KEY_F4 and pc4.visible:
			show_pc_sheet(4)
		elif event.keycode == KEY_F5 and pc5.visible:
			show_pc_sheet(5)
		elif event.keycode == KEY_F6:
			pc_button_disable(0)
			#save notes sheet in case already open, else changes will be lost
			get_tree().call_group("sheets", "save_and_close") 
			#overlay the notes sheet
			overlay_scene("res://main/notes_sheet.tscn")
		elif event.keycode == KEY_ESCAPE:
			if is_scene_overlayed:
				pc_button_disable(0)
				get_tree().call_group("sheets", "save_and_close")
				overlay_scene("res://main/empty.tscn")
			else:
				overlay_scene("res://main/menu.tscn")
		else:
			return
	get_viewport().set_input_as_handled()

func _on_pc_1_button_down():
	show_pc_sheet(1)
func _on_pc_2_button_down():
	show_pc_sheet(2)
func _on_pc_3_button_down():
	show_pc_sheet(3)
func _on_pc_4_button_down():
	show_pc_sheet(4)
func _on_pc_5_button_down():
	show_pc_sheet(5)

func show_pc_sheet(pc):
	get_tree().call_group("sheets", "save_and_close")
	pc_button_disable(pc)
	overlay_scene("res://main/pc_sheet.tscn")

func pc_button_disable(i):
	pc1.disabled = false
	pc2.disabled = false
	pc3.disabled = false
	pc4.disabled = false
	pc5.disabled = false
	if i == 1 or pc1.visible == false:
		pc1.disabled = true
		party_count = 0
	elif i == 2 or pc2.visible == false:
		pc2.disabled = true
		party_count = 1
	elif i == 3 or pc3.visible == false:
		pc3.disabled = true
		party_count = 2
	elif i == 4 or pc4.visible == false:
		pc4.disabled = true
		party_count = 3
	elif i == 5 or pc5.visible == false:
		pc5.disabled = true
		party_count = 4
	else:
		party_count = 5

func update_boxes():
	if Data.get_node("PC1").dict["first_name"] != null:
		pc1.update_box("PC1")
		
	if Data.get_node("PC2").dict["first_name"] != null:
		pc2.update_box("PC2")
		
	if Data.get_node("PC3").dict["first_name"] != null:
		pc3.update_box("PC3")
		
	if Data.get_node("PC4").dict["first_name"] != null:
		pc4.update_box("PC4")
		
	if Data.get_node("PC5").dict["first_name"] != null:
		pc5.update_box("PC5")


func _on_music_finished():
	music_select += 1
	if music_select > 4:
		music_select = 1
	$Audio/Music.stream = load("res://audio/music/" + str(music_select) + ".ogg")
	$Audio/Music.playing = true
	#$Music/Player.play("fade_in")
