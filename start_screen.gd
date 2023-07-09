extends Control

func _ready():
	#$BGM.set_loop(true) 
	pass
	
func _on_quit_pressed():
	get_tree().quit()

func _on_start_pressed():
	Global.current_fish = 1
	var game_scene = load("res://game_screen.tscn")
	var instance = game_scene.instantiate()
	add_child(instance)
	$startSFX.play()
