extends Node

var current_fish = 1
var cur_fish_id = 0
var fish_stat = []

var cur_fisher_id = 0
var fisher_stat = []

func _ready():
	init_fish()
	init_fisher()

func init_fish():
	var fish1 = {}
	fish1.init_stam_depletion = 10
	fish1.sprint_speed = 1.3
	fish1.dash_length = 80
	fish1.fish_up_speed = 2.5
	fish1.fish_down_speed = 2
	fish1.stam_depletion = 0.04
	fish1.stam_regen = 0.25
	
	var fish2 = {}
	fish2.init_stam_depletion = 17
	fish2.sprint_speed = 1.1
	fish2.dash_length = 200
	fish2.fish_up_speed = 1.7
	fish2.fish_down_speed = 1.7
	fish2.stam_depletion = 0.01
	fish2.stam_regen = 0.25
	
	var fish3 = {}
	fish3.init_stam_depletion = 5
	fish3.sprint_speed = 1.7
	fish3.dash_length = 20
	fish3.fish_up_speed = 2.7
	fish3.fish_down_speed = 2.7
	fish3.stam_depletion = 0.05
	fish3.stam_regen = 0.2

	fish_stat = [0,fish1,fish2,fish3]
	re_fish()

func re_fish():
	var x = randi()
	var new_fish_id = x % 3 + 1
	var cnt = 0
	while new_fish_id == cur_fish_id or cnt < 2:
		x = randi()
		new_fish_id = x % 3 + 1
		cnt += 1
		print(new_fish_id," ",cnt)
	cur_fish_id = new_fish_id
	
func get_fish_stat():
	return fish_stat[cur_fish_id]
	
func init_fisher():
	var fisher1 = {}
	fisher1.half_bar = 45
	fisher1.max_bar_speed = 1.3
	fisher1.intelligence = 850
	fisher1.gauge_pos_rate = 0.05
	fisher1.gauge_neg_rate = 0.1
	fisher1.bar_accel = 0.3
	
	var fisher2 = {}
	fisher2.half_bar = 60
	fisher2.max_bar_speed = 0.5
	fisher2.intelligence = 900
	fisher2.gauge_pos_rate = 0.05
	fisher2.gauge_neg_rate = 0.05
	fisher2.bar_accel = 0.2
	
	var fisher3 = {}
	fisher3.half_bar = 30
	fisher3.max_bar_speed = 1.9
	fisher3.intelligence = 950
	fisher3.gauge_pos_rate = 0.08
	fisher3.gauge_neg_rate = 0.05
	fisher3.bar_accel = 0.4
	
	var fisher4 = {}
	fisher4.half_bar = 20
	fisher4.max_bar_speed = 2.2
	fisher4.intelligence = 950
	fisher4.gauge_pos_rate = 0.1
	fisher4.gauge_neg_rate = 0.05
	fisher4.bar_accel = 0.5
	
	var fisher5 = {}
	fisher5.half_bar = 30
	fisher5.max_bar_speed = 2.1
	fisher5.intelligence = 1000
	fisher5.gauge_pos_rate = 0.04
	fisher5.gauge_neg_rate = 0.04
	fisher5.bar_accel = 0.3
	
	var fisher6 = {}
	fisher6.half_bar = 35
	fisher6.max_bar_speed = 3
	fisher6.intelligence = 1000
	fisher6.gauge_pos_rate = 0.05
	fisher6.gauge_neg_rate = 0.15
	fisher6.bar_accel = 0.8
	
	var fisher7 = {}
	fisher7.half_bar = 15
	fisher7.max_bar_speed = 2.9
	fisher7.intelligence = 500
	fisher7.gauge_pos_rate = 0.20
	fisher7.gauge_neg_rate = 0.06
	fisher7.bar_accel = 0.4
	
	fisher_stat = [0,fisher1,fisher2,fisher3,fisher4,fisher5,fisher6,fisher7]
	re_fisher()

func re_fisher():
	var x = randi()
	var mod
	var offset = 0
	if current_fish == 1:
		mod = 1
	elif current_fish < 5:
		mod = 3
	else:
		mod = 6
		offset = 1
	var new_fisher_id = x % mod + 1 + offset
	cur_fisher_id = new_fisher_id
	
func get_fisher_stat():
	var out = fisher_stat[cur_fisher_id]
	if current_fish > 5:
		out.intelligence *= 1.01 ** current_fish
		out.max_bar_speed += 0.1 * (current_fish/3)
		out.gauge_pos_rate += 0.01 * (current_fish/5)
	return out
