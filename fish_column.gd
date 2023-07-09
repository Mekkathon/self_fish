extends Node2D

signal game_win
signal game_lose

var min_cap = -231
var max_cap = 231

var stage_level

var bar_center
var fish_pos
var real_max_bar_speed

var cur_bar_speed = 0
var max_hold_frame = 30
var hold_frame = 0
var exhausted_speed = 0.3
var gauge = 0
var gauge_max = 100
var cur_intelligence

var game_over = false
var game_start = false
var countdown = 299
var sign = 1

var fish_stat
var fisher_stat

func _ready():
	Global.re_fisher()
	fish_stat = Global.get_fish_stat()
	fisher_stat = Global.get_fisher_stat()
	cur_intelligence = fisher_stat.intelligence
	$Fish.position = Vector2(0,0)
	$FishingBar.position = Vector2(-44,-fisher_stat.half_bar*2)
	$FishingBar.size = Vector2(22,fisher_stat.half_bar)
	$Gauge.set_value(50)
	$Stamina.set_value(100)
	real_max_bar_speed = fisher_stat.max_bar_speed
	$Fish.texture = load("res://asset/fish/fish0" + str(Global.cur_fish_id)  + ".png")

func _process(delta):
	#iframe += 1
	#if iframe == frame_div and not game_over:
	#	iframe = 0
	if not game_start:
		$Countdown.text = str(countdown/100+1)
	else:	
		if not game_over:
			update_fish()
			bar_move()
			update_gauge()
			
	if countdown == 0:
		game_start = true
		$Countdown.visible = false
		$ColorRect.visible = false
	else:
		countdown -= 1
	
func update_fish():
	var speed_mod = 1
	var fish_dash = false
	var stam = $Stamina.get_value()
	if Input.is_action_just_pressed("Dash"):
		if stam >= 5:
			stam -= fish_stat.init_stam_depletion
			fish_dash = true
	if Input.is_action_pressed("Dash"):
		stam -= fish_stat.stam_depletion
		stam = clamp(stam,-5,100)
		if stam <= 5:
			speed_mod = exhausted_speed
		else:
			speed_mod = fish_stat.sprint_speed
	else:
		stam += fish_stat.stam_regen
	$Stamina.set_value(stam)
	stam = clamp(stam,-20,100)
	var new_fish_pos = $Fish.position.y
	if Input.is_action_pressed("Rise"):
		if fish_dash:
			new_fish_pos -= fish_stat.dash_length
		new_fish_pos -= fish_stat.fish_up_speed * speed_mod
	else:
		if fish_dash:
			new_fish_pos += fish_stat.dash_length
		new_fish_pos += fish_stat.fish_down_speed * speed_mod
	fish_pos = clamp(new_fish_pos, -190, 190)
	bar_center = $FishingBar.position.y + fisher_stat.half_bar * 2
	$Fish.position = Vector2(0,fish_pos)

func bar_move():
	var new_bar_center
	if hold_frame == 0:
		sign = 1 if randi()%1000 < cur_intelligence else -1
	hold_frame += 1
		
	if hold_frame == max_hold_frame:
		hold_frame = 0

	if  bar_center < $Fish.position.y:
		cur_bar_speed += fisher_stat.bar_accel * sign
	else:
		cur_bar_speed -= fisher_stat.bar_accel * sign
	cur_bar_speed = clamp(cur_bar_speed,-real_max_bar_speed,real_max_bar_speed)
	new_bar_center = clamp(bar_center + cur_bar_speed, min_cap + 2*fisher_stat.half_bar + 10, max_cap - 2*fisher_stat.half_bar - 10)	
	$FishingBar.position = Vector2(-44,new_bar_center-fisher_stat.half_bar*2)
	$ColorRect2.size = Vector2(4,350+bar_center)

func update_gauge():
	var new_gauge
	var gauge = $Gauge.get_value()
	if abs(fish_pos - bar_center) <= 2 * fisher_stat.half_bar:
		new_gauge = clamp(gauge + fisher_stat.gauge_pos_rate, 0, 100)
	else:
		new_gauge = clamp(gauge - fisher_stat.gauge_neg_rate, 0, 100)
	if new_gauge < 15:
		cur_intelligence = 500 + fisher_stat.intelligence / 2
		real_max_bar_speed = fisher_stat.max_bar_speed * 1.2
		
	$Gauge.set_value(new_gauge)
	if new_gauge == 0:
		game_over = true
		game_win.emit()
	if new_gauge == 100:
		game_over = true
		game_lose.emit()

