# PlayerSuperpower
# Written by: First

extends PlayerEquipmentCore

class_name PlayerSuperpower

"""
	Enter desc here.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal filled

signal consumed

signal updated

#-------------------------------------------------
#      Constants
#-------------------------------------------------

const INPUT_ACTION_USE_SUPERPOWER = "game_a"
const SUPERPOWER_FILL_PTS = 1

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (bool) var can_fire = false setget set_can_fire


onready var player_proj_turret := $PlayerProjectileTurret as PlayerProjectileTurret


var current_power_pts : int setget set_current_power_pts

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	_connect_battleserver()
	_connect_level_gui_superpower_button()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

func _unleash():
	pass

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func has_superpower_database() -> bool:
	return equip_database != null

func get_superpower_database() -> ResItemEquipSuperpower:
	return equip_database as ResItemEquipSuperpower

func get_max_power_point() -> int:
	if not has_superpower_database():
		return ResItemEquipSuperpower.DEFAULT_MAX_POWER_PTS
	
	return get_superpower_database().hits_to_charge

func build_power() -> void:
	if not has_superpower_database():
		push_warning("Superpower database is not found. Can't gain pts.'")
		return
	
	if not is_superpower_filled():
		current_power_pts += SUPERPOWER_FILL_PTS
		
		if is_superpower_filled():
			emit_signal("filled")
			BattleServer.emit_signal("player_superpower_filled")
			LevelGUI.set_superpower_btn_disabled(false)
			AudioCenter.sfx_combat_super_ready.play()
	
	emit_signal("updated")

func is_superpower_filled() -> bool:
	return current_power_pts >= get_superpower_database().hits_to_charge

func consume():
	if not is_superpower_filled():
		return
	if not can_fire:
		return
	
	emit_signal("consumed")
	BattleServer.emit_signal("player_superpower_comsumed")
	set_current_power_pts(0)
	LevelGUI.set_superpower_btn_disabled(true)
	_unleash() #Virtual method
	
	emit_signal("updated")

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_BattleServer_enemy_hit_by_player_proj(enemy) -> void:
	build_power()

func _on_LevelGUI_superpower_button_down() -> void:
	consume()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _connect_battleserver():
	BattleServer.connect("enemy_hit", self, "_on_BattleServer_enemy_hit_by_player_proj")

func _connect_level_gui_superpower_button():
	LevelGUI.superpower_btn.connect("button_down", self, "_on_LevelGUI_superpower_button_down")

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_current_power_pts(val : int) -> void:
	current_power_pts = val

func set_can_fire(val : bool) -> void:
	can_fire = val
