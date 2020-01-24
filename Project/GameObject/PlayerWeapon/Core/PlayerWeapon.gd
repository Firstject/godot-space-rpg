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

export (PackedScene) var player_projectile

#If set to false, virtual method of _fire() will not work.
#Setting to true will allow the use of _fire() function.
export (bool) var custom_spawn_code

#Set disabled to false to make this weapon fires the bullet.
export (bool) var disabled = true setget set_disabled


var experience : int = 0

var current_lv : int = 1

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	update_shoot_timer_from_weapon_db()
	update_shoot_timer_state()
	_connect_battleserver()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

func _fire():
	pass

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

func update_shoot_timer_state():
	if self.disabled:
		$ShootTimer.stop()
	else:
		$ShootTimer.start()

#Should be called from _fire() function.
func spawn_projectile() -> PlayerProjectile:
	if player_projectile == null:
		push_warning(str(self, ": Can't spawn an empty projectile! Please set one."))
		return null
	
	var proj = player_projectile.instance()
	var sp_cy_node = get_tree().get_nodes_in_group("SpriteCycling")[0]
	sp_cy_node.get_parent().add_child(proj)
	_add_atk_to_projectile(proj)
	proj.global_position = self.global_position
	proj.set_level_from_entity(self)
	proj.clear_bonus_stats()
	proj.add_bonuses_from_entity(self)
	
	return proj

func gain_exp():
	if is_at_max_lv():
		return
	
	experience += 1
	if has_weapon_database():
		if experience >= get_weapon_database().experience_table[current_lv - 1]:
			current_lv += 1
			emit_signal("leveled_up")
			AudioCenter.beam_level.play()

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
	if custom_spawn_code:
		_fire()
	else:
		spawn_projectile()

func _on_BattleServer_enemy_killed(enemy) -> void:
	gain_exp()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _add_atk_to_projectile(proj : PlayerProjectile) -> void:
	if proj is PlayerProjectile:
		if not has_weapon_database():
			push_warning(str(self, ": Weapon database is null. No atk bonus added."))
		else:
			proj.atk += get_weapon_database().atk_bonus

func _connect_battleserver() -> void:
	BattleServer.connect("enemy_killed", self, "_on_BattleServer_enemy_killed")

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_disabled(val : bool) -> void:
	disabled = val
