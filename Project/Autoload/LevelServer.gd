# LevelServer
# Written by: First

extends Node

"""
	Enter desc here.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal level_ended

signal level_completed

signal level_failed

#-------------------------------------------------
#      Constants
#-------------------------------------------------

enum LevelEndCondition {
	COMPLETE,
	FAIL
}

#-------------------------------------------------
#      Properties
#-------------------------------------------------

var current_lv_scroll_spd : float

var current_bg_scroll_spd : float

var current_enemy_lv : int

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func end_level(condition : int):
	match condition:
		LevelEndCondition.COMPLETE:
			emit_signal("level_completed")
			emit_signal("level_ended")
			LevelGUI.start_level_clear_anim()
		LevelEndCondition.FAIL:
			emit_signal("level_failed")
			emit_signal("level_ended")
			LevelGUI.start_level_fail_anim()

func stop_scroll():
	current_bg_scroll_spd = 0
	current_lv_scroll_spd = 0

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

