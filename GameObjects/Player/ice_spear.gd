extends Area2D

@export var level = 1
@export var hp = 1
@export var speed = 100
@export var damage = 5
@export var knockback = 100
@export var size = 1.0
@export var target = Vector2.ZERO
@export var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")


func _ready():
	angle = position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	
	match level:
		1:
			hp = 1
			speed = 150
			damage = 5
			knockback = 100
			size = 1.0

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1) * size, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

func _physics_process(delta):
	position += angle * speed * delta


func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()


func _on_timer_timeout():
	queue_free()
