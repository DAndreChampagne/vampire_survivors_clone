extends Area2D

@export var damage: float = 1.0

@onready var collision = $CollisionShape2D
@onready var timer = $DisableHitBoxTimer


func tempdisable():
	collision.call_deferred("set", "disabled", true)
	timer.start()


func _on_disable_hit_box_timer_timeout():
	collision.call_deferred("set", "disabled", false)
