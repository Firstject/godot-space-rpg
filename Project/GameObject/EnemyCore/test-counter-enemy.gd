extends EnemyCore

func _ready() -> void:
	$BulletBehavior.angle_in_degrees += rand_range(-45, 45)

func _dead() -> void:
	var proj = $EnemyTurret.spawn_enemy_proj(self)
	proj.bullet_behavior.angle_in_degrees = rad2deg(proj.get_angle_to(get_player().global_position))
	proj.bullet_behavior.speed *= 2
