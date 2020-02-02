extends PlayerSuperpower

const SPREAD_COUNT = 32

func _unleash():
	AudioCenter.sfx_combat_ring_spread.play()
	
	for i in SPREAD_COUNT:
		var blt_hell = player_proj_turret.spawn_player_proj(self)
		blt_hell.bullet_behavior.angle_in_degrees = (360 / SPREAD_COUNT) * i
