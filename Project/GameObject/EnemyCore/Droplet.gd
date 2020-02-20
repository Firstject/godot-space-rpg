extends EnemyCore

func _process(delta: float) -> void:
	if global_position.x < -16 or global_position.x > 240:
		self.queue_free()

func _on_BulletBehavior_distance_travelled_reached() -> void:
	$BulletBehavior2.active = true
	$BulletBehavior.active = false
	if global_position.x > 112:
		$BulletBehavior2.angle_in_degrees = 240
	else:
		$BulletBehavior2.angle_in_degrees = -60
	$BulletBehavior2.speed *= 2
	
	$ShootTimer.start()

func _on_ShootTimer_timeout() -> void:
	var blt = $EnemyTurret.spawn_enemy_proj(self)
	blt.bullet_behavior.angle_in_degrees = rad2deg(blt.get_angle_to(get_player().global_position))
	AudioCenter.sfx_combat_enemy_shot1.play()
