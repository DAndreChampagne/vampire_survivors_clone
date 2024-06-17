extends CharacterBody2D

@export var movement_speed = Globals.movement_speed * 5
@export var hp = 80.0

@onready var sprite = $Sprite2D
@onready var walk_timer = $Timer


# Enemies
var enemiesInRange = []


# Attacks
@onready var attacks = $Attacks

# Ice Spear
var iceSpear = preload("res://GameObjects/Player/ice_spear.tscn")
@onready var ice_spear_timer = $Attacks/IceSpearTimer
@onready var ice_spear_attack_timer = $Attacks/IceSpearTimer/IceSpearAttackTimer
@export var iceSpearAmmo = 0
@export var iceSpearBaseAmmo = 2
@export var iceSpearAttackSpeed = 1.0
@export var iceSpearLevel = 1





func _ready():
	attack()


func _physics_process(delta):
	movement()
	
func _process(delta):
	pass


func attack():
	if iceSpearLevel > 0:
		ice_spear_timer.wait_time = iceSpearAttackSpeed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()


func movement():
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("down") - Input.get_action_strength("up")
	var direction = Vector2(x,y)
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
	
	if direction != Vector2.ZERO:
		if walk_timer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walk_timer.start()
	
	self.velocity = direction.normalized() * movement_speed
	
	move_and_slide()


func _on_hurt_box_hurt(damage):
	var b = hp
	hp -= damage
	print("player hurt: %d - %d = %d" % [b,damage,hp])


func _on_ice_spear_timer_timeout():
	iceSpearAmmo += iceSpearBaseAmmo
	ice_spear_attack_timer.start()


func _on_ice_spear_attack_timer_timeout():
	if iceSpearAmmo > 0:
		var target = get_random_target()
		if not target:
			return

		var attack = iceSpear.instantiate()
		attack.position = position
		attack.target = target
		attack.level = iceSpearLevel

#		print("attacking")
#		print("\tself.position: " + str(self.position))
#		print("\tself.global_position: " + str(self.global_position))
#		print("\tattack.position: " + str(attack.position))
#		print("\tattack.target: " + str(attack.target))
		
		add_child(attack)
		iceSpearAmmo -= 1

		if iceSpearAmmo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()


func get_random_target():
	if enemiesInRange.size() > 0:
		return enemiesInRange.pick_random().global_position
	return null
#	return Vector2.UP
			


func _on_enemy_detection_area_body_entered(body):
	if not enemiesInRange.has(body):
		enemiesInRange.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemiesInRange.has(body):
		enemiesInRange.erase(body)
