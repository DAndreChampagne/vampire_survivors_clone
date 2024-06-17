extends CharacterBody2D

@export var movement_speed: float = Globals.movement_speed * 0.5
@export var hp = 10.0

@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("walk")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed

	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false

	move_and_slide()


func _on_hurt_box_hurt(damage):
	hp -= damage
#	print("enemy hp left: " + str(hp))
	if hp <= 0:
		queue_free()
