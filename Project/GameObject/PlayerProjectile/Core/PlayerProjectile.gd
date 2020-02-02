# PlayerProjectileCore
# Written by: First

extends Entity

class_name PlayerProjectile

"""
	Enter desc here.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (PackedScene) var hit_effect

export (bool) var destroy_on_hit = true
export (bool) var hit_multiple = false
export (bool) var can_reset_hit = true

onready var bullet_behavior : BulletBehavior = $BulletBehavior as BulletBehavior

var is_hit = false

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _process(delta: float) -> void:
	#Test destroy on hit and then test reset hit
	_test_destroy_on_hit()
	_test_reset_hit()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func set_projectile_hit():
	is_hit = true

func can_projectile_hit() -> bool:
	return not is_hit or hit_multiple

func kill():
	if hit_effect != null:
		#Spawn effect
		var eff = hit_effect.instance()
		get_parent().add_child(eff)
		eff.global_position = global_position
	
	queue_free()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_VisibilityNotifier2D_screen_exited() -> void:
	self.queue_free()

func _on_Area2D_area_entered(area: Area2D) -> void:
	pass

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _test_reset_hit():
	if can_reset_hit:
		is_hit = false

func _test_destroy_on_hit():
	if is_hit and destroy_on_hit:
		kill()

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------


