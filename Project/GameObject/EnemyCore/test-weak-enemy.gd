extends EnemyCore

func _ready() -> void:
	$BulletBehavior.angle_in_degrees += rand_range(-45, 45)
