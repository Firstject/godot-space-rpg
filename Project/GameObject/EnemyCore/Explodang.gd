extends EnemyCore

var shoot_dir = [-40, -30, -20, -10, 0, 10, 20, 30, 40]

func _on_BulletBehavior_stopped_moving() -> void:
	for i in shoot_dir:
		var blt = $EnemyTurret.spawn_enemy_proj(self)
		blt.bullet_behavior.angle_in_degrees += i
	
	bullet_behavior.allow_negative_speed = true
	
	AudioCenter.sfx_combat_enemy_shot2.play()
