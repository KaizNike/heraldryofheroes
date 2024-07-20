extends MarginContainer

# Shortcut for the frame node where scenarios and player sheets are displayed
@onready var frame = get_node("HBox/Frame")
@onready var pc1 = get_node("HBox/Party/PC1Frame/PC1")
@onready var pc2 = get_node("HBox/Party/PC2Frame/PC2")
@onready var pc3 = get_node("HBox/Party/PC3Frame/PC3")
@onready var pc4 = get_node("HBox/Party/PC4Frame/PC4")
@onready var pc5 = get_node("HBox/Party/PC5Frame/PC5")

var current_scene = null
var over_scene = null

var music_select = 1

func _ready():
	current_scene = frame.get_child(0)
	over_scene = frame.get_child(1)
	
	$Music.stream = load("res://audio/music/" + str(music_select) + ".ogg")
	$Music.playing = true
	$Music.volume_db = -20

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

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

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	#get_tree().set_current_scene(current_scene)

# used to overlay player sheets on top of the current scene
# so able to switch back to the current scene after
func overlay_scene(path):
	call_deferred("_deferred_overlay_scene", path)

func _deferred_overlay_scene(path):
	over_scene.free()
	
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	over_scene = s.instantiate()

	# Add it to the active scene, as child of ScenarioFrame.
	frame.add_child(over_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	#get_tree().set_current_scene(over_scene)
func _unhandled_key_input(_event):
	if Input.is_key_pressed(KEY_F1) and pc1.visible:
		show_sheet(1)
	elif Input.is_key_pressed(KEY_F2) and pc2.visible:
		show_sheet(2)
	elif Input.is_key_pressed(KEY_F3) and pc3.visible:
		show_sheet(3)
	elif Input.is_key_pressed(KEY_F4) and pc4.visible:
		show_sheet(4)
	elif Input.is_key_pressed(KEY_F5) and pc5.visible:
		show_sheet(5)
	elif Input.is_key_pressed(KEY_F6):
		pc_button_disable(0)
		overlay_scene("res://main/NotesSheet.tscn")
	elif Input.is_key_pressed(KEY_ESCAPE):
		pc_button_disable(0)
		overlay_scene("res://main/Empty.tscn")
	else:
		return
	get_viewport().set_input_as_handled()

func _on_pc_1_button_down():
	show_sheet(1)
func _on_pc_2_button_down():
	show_sheet(2)
func _on_pc_3_button_down():
	show_sheet(3)
func _on_pc_4_button_down():
	show_sheet(4)
func _on_pc_5_button_down():
	show_sheet(5)

func show_sheet(pc):
	get_tree().call_group("sheets", "save_and_close")
	pc_button_disable(pc)
	overlay_scene("res://main/PCSheet.tscn")

func pc_button_disable(i):
	pc1.disabled = false
	pc2.disabled = false
	pc3.disabled = false
	pc4.disabled = false
	pc5.disabled = false
	if i == 1 or pc1.visible == false:
		pc1.disabled = true
	elif i == 2 or pc2.visible == false:
		pc2.disabled = true
	elif i == 3 or pc3.visible == false:
		pc3.disabled = true
	elif i == 4 or pc4.visible == false:
		pc4.disabled = true
	elif i == 5 or pc5.visible == false:
		pc5.disabled = true
	else:
		pass

func update_boxes():
	if Data.get_node("PC1").dict["first_name"] != null:
		get_node("HBox/Party/PC1Frame/PC1").update_box("PC1")
		
	if Data.get_node("PC2").dict["first_name"] != null:
		get_node("HBox/Party/PC2Frame/PC2").update_box("PC2")
		
	if Data.get_node("PC3").dict["first_name"] != null:
		get_node("HBox/Party/PC3Frame/PC3").update_box("PC3")
		
	if Data.get_node("PC4").dict["first_name"] != null:
		get_node("HBox/Party/PC4Frame/PC4").update_box("PC4")
		
	if Data.get_node("PC5").dict["first_name"] != null:
		get_node("HBox/Party/PC5Frame/PC5").update_box("PC5")


func _on_music_finished():
	music_select += 1
	if music_select > 4:
		music_select = 1
	$Music.stream = load("res://audio/music/" + str(music_select) + ".ogg")
	$Music.playing = true
	#$Music/Player.play("fade_in")
