# Script_Name_Here
# Written by: 

extends PlayerEquipmentCore

class_name PlayerWeaponCore

"""
	To create new weapon, inherit this node and set some script
	variables if needed.
	To gain more control over player's projectiles (in case you want
	to change some of the properties of spawned object), extend
	script and self-connect a signal 'spawned_projectile'.
	
	Override a function _fire() in an extended script and start coding.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal spawned_projectile(player_projectile)

signal leveled_up()

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (bool) var can_fire = false setget set_can_fire


onready var player_proj_turret := $PlayerProjectileTurret as PlayerProjectileTurret

var experience : int = 0

var current_lv : int = 1


#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	update_shoot_timer_from_weapon_db()
	$ShootTimer.start()
	_connect_battleserver()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

func _fire():
	player_proj_turret.spawn_player_proj(self)

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func update_shoot_timer_from_weapon_db() -> void:
	if not has_weapon_database():
		push_warning("Weapon database is empty. Now using default timer.")
		return
	
	$ShootTimer.set_wait_time(get_weapon_database().fire_rate)

func gain_exp():
	if is_at_max_lv():
		return
	
	experience += 1
	if has_weapon_database():
		if experience >= get_weapon_database().experience_table[current_lv - 1]:
			current_lv += 1
			emit_signal("leveled_up")
			AudioCenter.sfx_combat_beam_level_up.play()

func is_at_max_lv() -> bool:
	if has_weapon_database():
		return current_lv > get_weapon_database().experience_table.size()
	
	return true #Avoid error

func get_current_beam_lv() -> int:
	if has_weapon_database():
		for i in range(get_weapon_database().beam_upgrades.size() - 1, -1, -1):
			if current_lv >= get_weapon_database().beam_upgrades[i]:
				return i + 1
	
	return -1 #Not found

func get_weapon_database() -> ResItemEquipWeapon:
	return equip_database as ResItemEquipWeapon

func has_weapon_database() -> bool:
	return equip_database != null

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_ShootTimer_timeout() -> void:
	if can_fire:
		_fire()

func _on_BattleServer_enemy_killed(enemy) -> void:
	gain_exp()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _connect_battleserver() -> void:
	BattleServer.connect("enemy_killed", self, "_on_BattleServer_enemy_killed")

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_can_fire(val : bool) -> void:
	can_fire = val
