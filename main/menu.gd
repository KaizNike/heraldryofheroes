extends ColorRect

func _ready():
	$VBox/MusicVolume/MusicSlider.value = Data.settings["music_volume"]
	$VBox/SFXVolume/SFXSlider.value = Data.settings["sfx_volume"]
	$VBox/Continue.grab_focus()

func _on_continue_pressed():
	Main.overlay_scene("res://main/Empty.tscn")

func _on_new_game_pressed():
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
	
	Data.quart_hour = 32
	Data.time["hour"] = 8
	Data.time["day"] = 28
	Data.time["month"] = 2
	Data.time["year"] = 1400
	
	Data.save_game()
	Main.update_boxes()
	Main.overlay_scene("res://main/Empty.tscn")
	Main.goto_scene("res://scenarios/leipzig/inn_table/InnTable.tscn")

func _on_music_slider_value_changed(value):
	Data.settings["music_volume"] = value
	Main.get_node("Audio/Music").volume_db = value

func _on_sfx_slider_value_changed(value):
	Data.settings["sfx_volume"] = value
	Main.get_node("Audio/SFX").volume_db = value
	
	var anim: Animation = Main.get_node("Audio/SFX/Player").get_animation("fade_in")
	var key_id: int = anim.track_find_key(0, 1)
	anim.track_set_key_value(0, key_id, value)
	
	anim = Main.get_node("Audio/SFX/Player").get_animation("fade_out")
	key_id = anim.track_find_key(0, 0)
	anim.track_set_key_value(0, key_id, value)
	key_id = anim.track_find_key(0, 1)
	anim.track_set_key_value(0, key_id, Data.settings["sfx_volume"] * 3/4)

func _on_exit_game_pressed():
	Data.save_game()
	get_tree().quit()
