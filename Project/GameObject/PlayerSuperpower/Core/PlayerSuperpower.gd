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

const SUPERPOWER_FILL_PTS = 1

#-------------------------------------------------
#      Properties
#-------------------------------------------------

var current_power_pts : int setget set_current_power_pts

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	_connect_battleserver()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

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

func gain_power_pts() -> void:
	if not has_superpower_database():
		push_warning("Superpower database is not found. Can't gain pts.'")
		return
	
	if not is_superpower_filled():
		current_power_pts += SUPERPOWER_FILL_PTS
		
		if is_superpower_filled():
			emit_signal("filled")
	
	emit_signal("updated")

func is_superpower_filled() -> bool:
	return current_power_pts >= get_superpower_database().hits_to_charge

func consume():
	emit_signal("consumed")
	set_current_power_pts(0)
	
	emit_signal("updated")

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_BattleServer_enemy_hit_by_player_proj(enemy) -> void:
	gain_power_pts()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _connect_battleserver():
	BattleServer.connect("enemy_hit", self, "_on_BattleServer_enemy_hit_by_player_proj")

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_current_power_pts(val : int) -> void:
	current_power_pts = val
