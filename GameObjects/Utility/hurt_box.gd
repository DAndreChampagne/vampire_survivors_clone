extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var timer = $DisableTimer

signal hurt(damage)


func _on_area_entered(area):
	if area.is_in_group("attack"):
		if  area.get("damage") != null:
			match HurtBoxType:
				0:
					print("HurtBox entered (Cooldown)")
					collision.call_deferred("set", "disabled", true)
					timer.start()
				1:
					print("HurtBox entered (HitOnce)")
					pass
				2:
					print("HurtBox entered (DisableHitBox)")
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt", damage)


func _on_disable_timer_timeout():
	print("HurtBox cooldown complete")
	collision.call_deferred("set", "disabled", false)
