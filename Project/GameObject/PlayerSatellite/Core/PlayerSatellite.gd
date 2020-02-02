# PlayerSatellite
# Written by: First

extends PlayerEquipmentCore

class_name PlayerSatelliteCore

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

enum Slot {LEFT, RIGHT}

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (bool) var can_fire = false setget set_can_fire


onready var player_proj_turret := $PlayerProjectileTurret as PlayerProjectileTurret
onready var shoot_timer = $ShootTimer


var current_exp : int

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	_init_shoot_timer_from_db()
	_test_start_shoot_timer()
	_connect_battleserver()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

func _shoot() -> void:
	player_proj_turret.spawn_player_proj(self)

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func gain_exp() -> void:
	if is_at_max_exp():
		return
	
	current_exp += 1

func is_at_max_exp() -> bool:
	if has_satellite_database():
		return current_exp >= get_satellite_database().total_exp
	
	return false

func multiply_dmg_by_str() -> void:
	if not has_satellite_database():
		return
	
	var _min_firepower = get_satellite_database().atk_strength
	var _max_firepower = get_satellite_database().max_atk_strength
	var _exp_percent = current_exp / get_satellite_database().total_exp
	base_atk_bonus = (base_atk + base_atk_bonus) * lerp(_min_firepower, _max_firepower, _exp_percent)
	update_stats()

func has_satellite_database() -> bool:
	return equip_database != null

func get_satellite_database() -> ResItemEquipSatellite:
	return equip_database as ResItemEquipSatellite

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_ShootTimer_timeout():
	if can_fire:
		_shoot()

func _on_BattleServer_enemy_killed(enemy_obj):
	gain_exp()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _init_shoot_timer_from_db():
	if has_satellite_database():
		shoot_timer.set_wait_time(get_satellite_database().fire_rate)

func _test_start_shoot_timer():
	if not can_fire:
		return
	
	shoot_timer.start()

func _connect_battleserver() -> void:
	BattleServer.connect("enemy_killed", self, "_on_BattleServer_enemy_killed")

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_can_fire(val : bool) -> void:
	can_fire = val
