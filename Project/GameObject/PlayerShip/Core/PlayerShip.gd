# PlayerShip
# Written by: First

extends Entity

class_name PlayerShip

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

const LEVEL_END_ACCEL_SPD : float = 360.0

const TEMP_CUSTOM_WEAPON = preload("res://GameObject/PlayerWeapon/PulseCannon.tscn")
const TEMP_CUSTOM_SHIELD = preload("res://GameObject/PlayerShield/test-shield.tscn")
const TEMP_CUSTOM_SATELLITE = preload("res://GameObject/PlayerSatellite/test-satellite.tscn")
const TEMP_CUSTOM_SUPERPOWER = preload("res://GameObject/PlayerSuperpower/test-player-superpower.tscn")
const TEMP_CUSTOM_MODULE = preload("res://GameObject/PlayerModule/NanofiberStructure.tscn")

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (bool) var can_control = false setget set_can_control


onready var pose_blt_bhv = $PoseBltBhv
onready var ctrl_8dir_bhv = $Controls/EightDirectionBehavior
onready var player_ship_touch_ctrler = $Controls/PlayerShipTouchController
onready var exp_system := $ExperienceSystem as ExperienceSystem
onready var damage_area2d = $Hitbox/DamageArea2D
onready var damage_anim = $DamageAnim
onready var damage_popup_turret = $DamagePopupTurret
onready var shield_damage_popup_turret = $ShieldDamagePopupTurret
onready var invincible_state := $InvincibleState as InvincibleState

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	_install_player_weapon()
	_install_player_shield()
	_install_player_satellites()
	_install_player_superpower()
	_install_player_modules()
	_update_controllables()
	recalculate_bonuses()
	_connect_levelserver()
	_connect_battleserver()
	exp_system.set_current_level(lv)
	_update_gui()

func _process(delta: float) -> void:
	if global_position.x < 8:
		global_position.x = 8
	if global_position.x > 216:
		global_position.x = 216
	if global_position.y < 8:
		global_position.y = 8
	if global_position.y > 392:
		global_position.y = 392

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func pose_stage_enter() -> void:
	pose_blt_bhv.active = true

func recalculate_bonuses():
	clear_bonus_stats()
	_add_bonus_stats_from_equipments()
	update_stats()
	_update_modules_stat()
	

func take_damage_from_enemy(enemy : Entity):
	if not can_be_damaged_by(enemy):
		return
	if invincible_state.is_invincible():
		return
	
	var total_dmg = calculate_take_damage_from_entity(enemy)
	var is_colliding_enemy = enemy.is_collider
	
	#If collided with a collider, then the damage is doubled.
	if is_colliding_enemy:
		total_dmg *= 2
	
	#If the player has a shield equipped and not in collision with
	#the enemy that is a collider, make the shield absorb
	#the damage.
	if not is_colliding_enemy:
		if has_shield():
			total_dmg = get_shield().absorb(total_dmg)
	else:
		if has_shield():
			get_shield().set_previous_absorbed_damage(0)
			get_shield().interrupt()
	
	take_damage(total_dmg)
	
	#Spawn damage popup.
	if total_dmg == 0: #No damage taken to the ship at all
		if has_shield():
			shield_damage_popup_turret.spawn_damage_popup(get_shield().previous_absorbed_damage, DamagePopup.DamageType.NO_DAMAGE)
		else:
			damage_popup_turret.spawn_damage_popup(0, DamagePopup.DamageType.NO_DAMAGE)
		AudioCenter.sfx_combat_shield_block.play()
	else: #Ship takes damage
		if has_shield() and get_shield().previous_absorbed_damage > 0:
			shield_damage_popup_turret.spawn_damage_popup(get_shield().previous_absorbed_damage, DamagePopup.DamageType.NO_DAMAGE)
			AudioCenter.sfx_combat_shield_block.play()
		
		if not previous_is_crit_taken:
			damage_popup_turret.spawn_damage_popup(total_dmg, DamagePopup.DamageType.PLAYER)
		else:
			damage_popup_turret.spawn_damage_popup(total_dmg, DamagePopup.DamageType.PLAYER_CRITICAL)
		
		#Make UI shake and show damage overlay
		LevelGUI.play_dmg_anim()
		
		AudioCenter.sfx_combat_player_damage.play()
	
	#Become invincible for a short while.
	#Will not trigger this if collided with enemy projectile.
	if has_shield():
		if get_shield().is_power_depleted() and total_dmg != 0:
			invincible()
		elif enemy.apply_invinc_on_collide_player:
			invincible()
	else:
		invincible()
	
	# under construction ...

func invincible():
	#Check for death
	if is_dead():
		AudioCenter.stop_bgm()
		AudioCenter.sfx_combat_player_kill.play()
		set_can_control(false)
		$Hitbox/DamageArea2D.set_monitoring(false)
		$Hitbox/DamageArea2D.set_deferred("monitorable", false)
		$PickupsCollector.queue_free()
		damage_anim.play("Death")
		BattleServer.emit_signal("player_dead", self)
	else:
		invincible_state.start_invincibility()
		damage_anim.play("DamageLoop")

func has_weapon() -> bool:
	for i in $ShipComponents/Weapon.get_children():
		if i is PlayerWeaponCore:
			return true
	
	return false

func get_weapon() -> PlayerWeaponCore:
	for i in $ShipComponents/Weapon.get_children():
		if i is PlayerWeaponCore:
			return i
	
	return null

func has_shield() -> bool:
	for i in $ShipComponents/Shield.get_children():
		if i is PlayerShieldCore:
			return true
	
	return false

func get_shield() -> PlayerShieldCore:
	for i in $ShipComponents/Shield.get_children():
		if i is PlayerShieldCore:
			return i
	
	return null

func has_superpower() -> bool:
	for i in $ShipComponents/Superpower.get_children():
		if i is PlayerSuperpower:
			return true
	
	return false

func get_superpower() -> PlayerSuperpower:
	for i in $ShipComponents/Superpower.get_children():
		if i is PlayerSuperpower:
			return i
	
	return null

func has_satellite(slot_idx : int) -> bool:
	if slot_idx == PlayerSatelliteCore.Slot.LEFT and $ShipComponents/Satellites.get_child(slot_idx) is PlayerSatelliteCore:
		return true
	if slot_idx == PlayerSatelliteCore.Slot.RIGHT and $ShipComponents/Satellites.get_child(slot_idx) is PlayerSatelliteCore:
		return true
	
	return false

func get_satellite(slot_idx : int) -> PlayerSatelliteCore:
	return $ShipComponents/Satellites.get_child(slot_idx) as PlayerSatelliteCore

func get_modules() -> Array:
	return $ShipComponents/Modules.get_children()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_InvincibleState_stopped():
	damage_anim.play("DamageFinish")
	damage_area2d.set_monitoring(false)
	damage_area2d.set_monitoring(true)

func _on_PlayerShip_took_damage() -> void:
	_update_gui()

func _on_shield_updated():
	_update_gui()

func _on_superpower_updated():
	_update_gui()

#This one is calling all the time
func _on_PoseBltBhv_stopped_moving():
	set_can_control(true)

func _on_ExperienceSystem_level_up() -> void:
	self.lv += 1
	
	recalculate_bonuses()
	_update_gui()
	LevelGUI.play_level_up_anim()
	
	AudioCenter.sfx_combat_level_up.play()

func _on_BattleServer_enemy_killed(enemy_obj) -> void:
	#enemy_obj is not directly casted to avoid cyclic recursion
	exp_system.gain_exp(enemy_obj.exp_system.get_exp_drop())
	_update_gui()

func _on_LevelServer_level_completed() -> void:
	set_can_control(false)
	pose_blt_bhv.current_acceleration = 0
	pose_blt_bhv.speed = 0
	pose_blt_bhv.velocity = Vector2.ZERO
	pose_blt_bhv.acceleration = LEVEL_END_ACCEL_SPD
	pose_blt_bhv.active = true
	damage_area2d.set_monitoring(false)
	damage_area2d.set_monitorable(false)

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _add_bonus_stats_from_equipments() -> void:
	if has_weapon():
		if get_weapon().has_equip_database():
			base_hp_bonus += get_weapon().get_equip_database().hp_bonus
			base_atk_bonus += get_weapon().get_equip_database().atk_bonus
			base_def_bonus += get_weapon().get_equip_database().def_bonus
			crit_rate_bonus += get_weapon().get_equip_database().crit_rate_bonus
			crit_damage_rate_bonus += get_weapon().get_equip_database().crit_damage_rate_bonus
	if has_shield():
		if get_shield().has_equip_database():
			base_hp_bonus += get_shield().get_equip_database().hp_bonus
			base_atk_bonus += get_shield().get_equip_database().atk_bonus
			base_def_bonus += get_shield().get_equip_database().def_bonus
			crit_rate_bonus += get_shield().get_equip_database().crit_rate_bonus
			crit_damage_rate_bonus += get_shield().get_equip_database().crit_damage_rate_bonus
	if has_superpower():
		if get_superpower().has_equip_database():
			base_hp_bonus += get_superpower().get_equip_database().hp_bonus
			base_atk_bonus += get_superpower().get_equip_database().atk_bonus
			base_def_bonus += get_superpower().get_equip_database().def_bonus
			crit_rate_bonus += get_superpower().get_equip_database().crit_rate_bonus
			crit_damage_rate_bonus += get_superpower().get_equip_database().crit_damage_rate_bonus
	if has_satellite(PlayerSatelliteCore.Slot.LEFT):
		if get_satellite(PlayerSatelliteCore.Slot.LEFT).has_equip_database():
			base_hp_bonus += get_satellite(PlayerSatelliteCore.Slot.LEFT).get_equip_database().hp_bonus
			base_atk_bonus += get_satellite(PlayerSatelliteCore.Slot.LEFT).get_equip_database().atk_bonus
			base_def_bonus += get_satellite(PlayerSatelliteCore.Slot.LEFT).get_equip_database().def_bonus
			crit_rate_bonus += get_satellite(PlayerSatelliteCore.Slot.LEFT).get_equip_database().crit_rate_bonus
			crit_damage_rate_bonus += get_satellite(PlayerSatelliteCore.Slot.LEFT).get_equip_database().crit_damage_rate_bonus
	if has_satellite(PlayerSatelliteCore.Slot.RIGHT):
		if get_satellite(PlayerSatelliteCore.Slot.RIGHT).has_equip_database():
			base_hp_bonus += get_satellite(PlayerSatelliteCore.Slot.RIGHT).get_equip_database().hp_bonus
			base_atk_bonus += get_satellite(PlayerSatelliteCore.Slot.RIGHT).get_equip_database().atk_bonus
			base_def_bonus += get_satellite(PlayerSatelliteCore.Slot.RIGHT).get_equip_database().def_bonus
			crit_rate_bonus += get_satellite(PlayerSatelliteCore.Slot.RIGHT).get_equip_database().crit_rate_bonus
			crit_damage_rate_bonus += get_satellite(PlayerSatelliteCore.Slot.RIGHT).get_equip_database().crit_damage_rate_bonus
	for i in get_modules():
		if i is PlayerModule:
			if i.has_equip_database():
				base_hp_bonus += i.get_equip_database().hp_bonus
				base_atk_bonus += i.get_equip_database().atk_bonus
				base_def_bonus += i.get_equip_database().def_bonus
				crit_rate_bonus += i.get_equip_database().crit_rate_bonus
				crit_damage_rate_bonus += i.get_equip_database().crit_damage_rate_bonus

func _install_player_weapon():
	push_warning("Installing TEMP_CUSTOM_WEAPON as an unintended feature.")
	
	var weap = TEMP_CUSTOM_WEAPON.instance()
	$ShipComponents/Weapon.add_child(weap)

func _install_player_shield():
	push_warning("Installing TEMP_CUSTOM_SHIELD as an unintended feature.")
	
	var shield = TEMP_CUSTOM_SHIELD.instance()
	$ShipComponents/Shield.add_child(shield)
	
	shield.connect("power_updated", self, "_on_shield_updated")

func _install_player_satellites():
	push_warning("Installing TEMP_CUSTOM_SATELLITE as an unintended feature.")
	
	var satellite1 = TEMP_CUSTOM_SATELLITE.instance()
	$ShipComponents/Satellites.add_child(satellite1)
	satellite1.position += Vector2(-30, 20)
	var satellite2 = TEMP_CUSTOM_SATELLITE.instance()
	satellite2.position += Vector2(30, 20)
	$ShipComponents/Satellites.add_child(satellite2)

func _install_player_superpower():
	push_warning("Installing TEMP_CUSTOM_SUPERPOWER as an unintended feature.")
	
	var superpower = TEMP_CUSTOM_SUPERPOWER.instance()
	$ShipComponents/Superpower.add_child(superpower)
	
	superpower.connect("updated", self, "_on_superpower_updated")

func _install_player_modules():
	push_warning("Installing TEMP_CUSTOM_MODULES as an unintended feature.")
	
	var module1 = TEMP_CUSTOM_MODULE.instance()
	$ShipComponents/Modules.add_child(module1)
	var module2 = TEMP_CUSTOM_MODULE.instance()
	$ShipComponents/Modules.add_child(module2)
	var module3 = TEMP_CUSTOM_MODULE.instance()
	$ShipComponents/Modules.add_child(module3)
	var module4 = TEMP_CUSTOM_MODULE.instance()
	$ShipComponents/Modules.add_child(module4)

func _update_modules_stat():
	if has_weapon():
		get_weapon().set_level_from_entity(self)
		get_weapon().clear_bonus_stats()
		get_weapon().add_bonuses_from_entity(self)
	if has_shield():
		get_shield().update_max_power(self.max_hp)
	if has_satellite(PlayerSatelliteCore.Slot.LEFT):
		get_satellite(PlayerSatelliteCore.Slot.LEFT).set_level_from_entity(self)
		get_satellite(PlayerSatelliteCore.Slot.LEFT).clear_bonus_stats()
		get_satellite(PlayerSatelliteCore.Slot.LEFT).add_bonuses_from_entity(self)
		get_satellite(PlayerSatelliteCore.Slot.LEFT).multiply_dmg_by_str()
	if has_satellite(PlayerSatelliteCore.Slot.RIGHT):
		get_satellite(PlayerSatelliteCore.Slot.RIGHT).set_level_from_entity(self)
		get_satellite(PlayerSatelliteCore.Slot.RIGHT).clear_bonus_stats()
		get_satellite(PlayerSatelliteCore.Slot.RIGHT).add_bonuses_from_entity(self)
		get_satellite(PlayerSatelliteCore.Slot.RIGHT).multiply_dmg_by_str()
	if has_superpower():
		get_superpower().set_level_from_entity(self)
		get_superpower().clear_bonus_stats()
		get_superpower().add_bonuses_from_entity(self)

func _update_gui() -> void:
	LevelGUI.update_player_status(self)

func _update_controllables() -> void:
	ctrl_8dir_bhv.active = can_control
	player_ship_touch_ctrler.active = can_control
	
	#Change the shooting state of weapon, satellite, and superpower.
	if has_weapon():
		get_weapon().set_can_fire(can_control)
	if has_satellite(PlayerSatelliteCore.Slot.LEFT):
		get_satellite(PlayerSatelliteCore.Slot.LEFT).set_can_fire(can_control)
	if has_satellite(PlayerSatelliteCore.Slot.RIGHT):
		get_satellite(PlayerSatelliteCore.Slot.RIGHT).set_can_fire(can_control)
	if has_superpower():
		get_superpower().set_can_fire(can_control)

func _connect_battleserver():
	BattleServer.connect("enemy_killed", self, "_on_BattleServer_enemy_killed")

func _connect_levelserver():
	LevelServer.connect("level_completed", self, "_on_LevelServer_level_completed")

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_can_control(val : bool) -> void:
	can_control = val
	_update_controllables()


