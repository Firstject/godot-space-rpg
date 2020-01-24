# Extended version of bullet behavior i guess
# Written by: M_rYuin

extends BulletBehavior

enum SpeedSetting {
	LEVEL_SCROLL_SPEED,
	BG_SCROLL_SPEED
}

export (SpeedSetting) var speed_setting

func _process(delta: float) -> void:
	match speed_setting:
		SpeedSetting.BG_SCROLL_SPEED:
			speed = LevelServer.current_bg_scroll_spd
		SpeedSetting.LEVEL_SCROLL_SPEED:
			speed = LevelServer.current_lv_scroll_spd
	
