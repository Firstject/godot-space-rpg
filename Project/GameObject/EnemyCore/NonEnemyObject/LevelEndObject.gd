# LevelEndObject (EnemyCore)
# Written by: First

extends EnemyCore

"""
	Ends the level as soon as this enemy object is spawned.
	This should be spawned by EnemySpawner.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

onready var force_end_timer = $ForceEndTimer

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	_connect_battleserver()
	end_level()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func end_level(force_end : bool = false):
	LevelServer.stop_scroll()
	
	if can_end_level() or force_end:
		LevelServer.end_level(LevelServer.LevelEndCondition.COMPLETE)
		queue_free()

func can_end_level() -> bool:
	return (
		BattleServer.total_enemy_count <= 0 and
		BattleServer.total_pickups_count <= 0
	)

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_EndCheckIntervalTimer_timeout() -> void:
	end_level()

func _on_ForceEndTimer_timeout() -> void:
	end_level(true)
	push_warning("Level is forced ending. Update how this works on boss implementation in the future.")

func _on_BattleServer_enemy_killed(enemy_obj):
	_restart_force_end_timer()

func _on_BattleServer_player_dead():
	self.queue_free()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _connect_battleserver():
	BattleServer.connect("enemy_killed", self, "_on_BattleServer_enemy_killed")
	BattleServer.connect("player_dead", self, "_on_BattleServer_player_dead")

func _restart_force_end_timer():
	force_end_timer.start()

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

