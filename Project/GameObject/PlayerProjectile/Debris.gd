extends PlayerProjectile

class_name PlayerProjectileDebris

const PROJECTILE_SPEED_MIN = 90
const PROJECTILE_SPEED_MAX = 250
const DURATION_MIN : float = 0.5
const DURATION_MAX : float = 1.1

onready var anim = $AnimationPlayer

var stop_action_playing : bool = false


func _ready():
	_init_projectile_data()

func _init_projectile_data():
	var _duration = rand_range(DURATION_MIN, DURATION_MAX)
	var _speed = rand_range(PROJECTILE_SPEED_MIN, PROJECTILE_SPEED_MAX)
	
	bullet_behavior.speed = _speed
	bullet_behavior.acceleration = -(_speed / _duration)
	bullet_behavior.angle_in_degrees = rand_range(0, 360)

func _on_BulletBehavior_stopped_moving():
	stop_action()
	bullet_behavior.queue_free()

func stop_action():
	if stop_action_playing:
		return
	else:
		stop_action_playing = true
	
	can_hit = false
	can_damage = false
	anim.play("Deleting")

#Override
func kill():
	stop_action()
