extends EnemyCore

const DELAY_TIMER_MIN = 0.1
const DELAY_TIMER_MAX = 1.2

func _ready() -> void:
	$DelayTimer.wait_time = rand_range(DELAY_TIMER_MIN, DELAY_TIMER_MAX)
	$DelayTimer.start()

func _on_ShootTimer_timeout() -> void:
	var proj : EnemyProjectileCore = $EnemyTurret.spawn_enemy_proj(self)
	
	proj.bullet_behavior.angle_in_degrees += rand_range(-20, 20)
	AudioCenter.enemy_shoot_slow.play()

func _on_DelayTimer_timeout() -> void:
	$ShootTimer.start()
