extends EnemyCore



func _on_ShootTimer_timeout() -> void:
	if get_player().global_position.y > global_position.y:
		var proj = $EnemyTurret.spawn_enemy_proj(self)
		proj.bullet_behavior.angle_in_degrees = rad2deg(proj.get_angle_to(get_player().global_position))
		AudioCenter.sfx_combat_enemy_shot1.play()
	
	$ShootTimer.wait_time = rand_range(1, 5)
	$ShootTimer.start()
	
	
