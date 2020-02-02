extends EnemyCore

var shoot_angle_sequences = [
	50, 45, 40, 35, 30,
	22, 45, 67, 90, 112,
	15, 30, 45, 60, 75,
	5, 4, 3, 2, 1
]
var current_shoot_idx = 0
var magazine = 10

func _on_ShootTimer_timeout() -> void:
	if magazine == 0:
		return
	
	#Bounce up
	$BulletBehavior.current_gravity = -80
	
	#Fire bullet on each side
	for i in 5:
		var proj : EnemyProjectileCore = $EnemyTurret.spawn_enemy_proj(self)
		var proj2 : EnemyProjectileCore = $EnemyTurret.spawn_enemy_proj(self)
		
		proj.bullet_behavior.angle_in_degrees += shoot_angle_sequences[wrapi(current_shoot_idx, 0, shoot_angle_sequences.size())]
		proj.bullet_behavior.speed -= i * 5
		proj2.bullet_behavior.angle_in_degrees += -shoot_angle_sequences[wrapi(current_shoot_idx, 0, shoot_angle_sequences.size())]
		proj2.bullet_behavior.speed -= i * 5
		current_shoot_idx += 1
	
	#Decrease magazine
	magazine -= 1
	
	#Full speed if magazine ran out
	if magazine == 0:
		$BulletBehavior.max_fall_speed = 999
		$BulletBehavior.gravity = 150
	
	AudioCenter.sfx_combat_enemy_shot2.play()
