extends CharacterBody2D

@export var movement_speed = Globals.movement_speed * 5
@export var hp = 80.0

@onready var sprite = $Sprite2D
@onready var walk_timer = $Timer


func _physics_process(delta):
	movement()
	
func _process(delta):
	pass
	

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
	hp -= damage
	print("player hp left: " + str(hp))
