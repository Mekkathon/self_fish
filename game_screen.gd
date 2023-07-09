extends Node2D

@onready var fish_game = $FishCol/FishColumn
# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.visible = false
	set_fish(0)

func set_fish(i):
	if i > 0:
		Global.re_fish()
	$Label.text = "fish\n#" + str(Global.current_fish)
	$Control/Fish.texture = load("res://asset/fish/fish0" + str(Global.cur_fish_id)  + ".png")

func _on_fish_column_game_lose():
	$loseSFX.play()
	$AnimationPlayer.play("Bake")
	get_parent().get_node("BGM").set_volume_db(-20)
	$Control.visible = true
	$Control/Next.disabled = true
	$Control/Label.text = "CAPTURED"
	$Control/Label2.text = "score: " + str(Global.current_fish - 1)

func _on_fish_column_game_win():
	$winSFX.play()
	get_parent().get_node("BGM").set_volume_db(-20)
	$Control.visible = true
	$Control/Label.text = "ESCAPED"
	$Control/Label2.text = "score: " + str(Global.current_fish)

func _on_back_pressed():
	get_parent().get_node("BGM").set_volume_db(0)
	queue_free()

func _on_next_pressed():
	get_parent().get_node("BGM").set_volume_db(0)
	Global.current_fish += 1
	set_fish(1)
	var fish_scene = load("res://fish_column.tscn")
	var instance = fish_scene.instantiate()
	instance.position = Vector2(179,324)
	instance.z_index = 0
	instance.game_win.connect(_on_fish_column_game_win)
	instance.game_lose.connect(_on_fish_column_game_lose)
	fish_game.queue_free()
	$FishCol.add_child(instance)
	fish_game = instance
	$Control.visible = false
