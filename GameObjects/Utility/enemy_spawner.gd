extends Node2D

@export var spawns: Array[SpawnInfo] = []
@export var time = 0

@onready var player = get_tree().get_first_node_in_group("player")


func _on_timer_timeout():
	time += 1
	
	for x in spawns:
		if (time >= x.time_start and time <= x.time_end):		
			if x.spawn_delay_counter < x.enemy_spawn_delay:
				x.spawn_delay_counter += 1
			else:
				x.spawn_delay_counter = 0

				for counter in range(x.enemy_num):
					var spawned_enemy = x.enemy.instantiate()
					var p = get_random_position()
					spawned_enemy.global_position = p
					add_child(spawned_enemy)
					print("Enemy spawned at " + str(spawned_enemy.global_position))
					counter += 1

func get_random_position() -> Vector2:
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_size = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_size:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
			
	var xspawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var yspawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	
	return Vector2(xspawn, yspawn)
	
	
