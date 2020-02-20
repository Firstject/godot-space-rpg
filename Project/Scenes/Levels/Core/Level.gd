# LevelCore
# Written by: First

extends Node

class_name LevelCore

"""
	Enter desc here.
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

const TEST_PLAYER_SHIP = preload("res://GameObject/PlayerShip/test-player-ship.tscn")

const DEFAULT_PLAYER_SPAWN_LOCATION = Vector2(112, 500)

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (String) var level_name = "None Star"

export (AudioStreamOGGVorbis) var level_music

export (float) var lv_scroll_speed = 20.0

export (float) var bg_scroll_speed = 5.0

export (int) var enemy_lv = 1

export (bool) var autostart_stage_enter_pose = true

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	LevelGUI.playfield_input.mouse_filter = Control.MOUSE_FILTER_STOP
	
	_init_level_server_data()
	LevelGUI.set_gui_visible(true)
	
	#Stage enter animations
	if autostart_stage_enter_pose:
		LevelGUI.update_level_name(level_name)
		LevelGUI.start_stage_enter_anim()
	
	_spawn_player_ship()
	_play_bgm()
	
	BattleServer.reset_all_counters()
	
	LevelGUI.get_node("LevelText/Panel/LevelLabel").text = str("Enemy lv: ", enemy_lv)

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _init_level_server_data() -> void:
	LevelServer.current_bg_scroll_spd = bg_scroll_speed
	LevelServer.current_lv_scroll_spd = lv_scroll_speed
	LevelServer.current_enemy_lv = enemy_lv

func _play_bgm() -> void:
	AudioCenter.play_bgm(level_music)

func _spawn_player_ship() -> void:
	var pship = TEST_PLAYER_SHIP.instance()
	
	$Objects.add_child(pship)
	pship.global_position = DEFAULT_PLAYER_SPAWN_LOCATION
	pship.pose_stage_enter()
	push_warning(str(self.get_path(), ": spawn player ship using custom test ship is not intended as a feature. Change it in the future."))

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

