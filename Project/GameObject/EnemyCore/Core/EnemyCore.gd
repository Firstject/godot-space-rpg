# EnemyCore
# Written by: First

extends Entity

class_name EnemyCore

"""
	Enemy can be the ship, bullet, or even the boss.
	The state of BulletBehavior is off by default.
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

const debris_obj = preload("res://GameObject/PlayerProjectile/Debris.tscn")
const EXPLOSION_EFF = preload("res://GameObject/Effect/ExplosionEffect.tscn")

const DEBRIS_KILL_EXP_MULTIPLIER = 2
const CREDIT_MULTIDROP_RAND_VALUE_FACTOR = 0.5

enum DeathSfx {
	NORMAL,
	LARGE
}

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (int) var experience = 10

export (int) var credits_base = 3

export (float) var credits_drop_chance = 0.35

export (int) var credits_drop_count = 1

export (int) var debris_count = 3

export (int) var debris_damage = 10

export (DeathSfx) var death_sound

export (bool) var destroy_on_collide = false

export (bool) var apply_invinc_on_collide_player = true

#The enemy is considered as collision damage when true.
export (bool) var is_collider = true

export (bool) var can_take_collision_damage = true

export (bool) var destroy_outside_screen = true

#When true, this enemy is counted as total enemies on the screen
#by BattleServer. Serves the purpose for when the level is about to
#finished. DO NOT CHANGE THIS AT RUNTIME!
export (bool) var is_battleserver_countable = true

onready var bullet_behavior : BulletBehavior = $BulletBehavior as BulletBehavior
onready var damage_anim := $DamageAnimationPlayer
onready var damage_popup_turret := $DamagePopupTurret
onready var pickups_turret := $PickupsTurret as PickupsTurret
onready var exp_system := $ExperienceSystem as ExperienceSystem

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	_init_exp_system()
#	_init_pickups_turret()
	_battleserver_change_total_enemy_count(1)

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func get_total_experience_by_lv() -> int:
	return experience

func get_player() -> PlayerShip:
	return get_tree().get_nodes_in_group("PlayerShip").back()

func collide_with_player_projectile(proj : PlayerProjectile):
	if not proj.can_projectile_hit():
		return
	if not can_be_damaged_by(proj):
		return
	if is_dead():
		return
	
	take_damage(calculate_take_damage_from_entity(proj))
	
	if is_killed_by_debris(proj):
		exp_system.multiply_exp_drop(DEBRIS_KILL_EXP_MULTIPLIER)
		AudioCenter.sfx_combat_debris_kill.play()
	
	damage_anim.play("Damage")
	
	#Spawn damage popup
	if not previous_is_crit_taken:
		damage_popup_turret.spawn_damage_popup(previous_damage_taken, DamagePopup.DamageType.ENEMY)
	else:
		damage_popup_turret.spawn_damage_popup(previous_damage_taken, DamagePopup.DamageType.ENEMY_CRITICAL)
	
	proj.set_projectile_hit()
	
	#Notify BattleServer about getting hit.
	BattleServer.emit_signal("enemy_hit_by_player_proj", self)
	BattleServer.emit_signal("enemy_hit", self)
	
	_test_kill()
	
	#under construction....

func collide_with_player_ship(pship : PlayerShip):
	var is_player_invinc = pship.invincible_state.is_invincible()
	
	pship.take_damage_from_enemy(self)
	
	#Queue free the enemy when destroy_on_collide is true
	if destroy_on_collide and not is_player_invinc:
		queue_free()
	
	#Take collision damage when can_take_collision_damage is true.
	if can_take_collision_damage and not is_player_invinc:
		take_damage(calculate_take_damage_from_entity(pship))
		damage_anim.play("Damage")
		
		#Spawn damage popup
		if not previous_is_crit_taken:
			damage_popup_turret.spawn_damage_popup(previous_damage_taken, DamagePopup.DamageType.ENEMY)
		else:
			damage_popup_turret.spawn_damage_popup(previous_damage_taken, DamagePopup.DamageType.ENEMY_CRITICAL)
		
		BattleServer.emit_signal("enemy_hit", self)
	
	_test_kill()
	
	#under construction

func kill() -> void:
	#Tell BattleServer that this enemy is killed
	BattleServer.emit_signal("enemy_killed", self)
	
	_spawn_debris()
	_spawn_main_currency()
	
	#Play death sfx
	match death_sound:
		DeathSfx.NORMAL:
			AudioCenter.sfx_combat_enemy_dead1.play()
			AudioCenter.sfx_combat_enemy_dead1.pitch_scale = rand_range(0.8, 1.2)
		DeathSfx.LARGE:
			AudioCenter.sfx_combat_enemy_dead2.play()
			AudioCenter.sfx_combat_enemy_dead2.pitch_scale = rand_range(0.8, 1.2)
	
	#Spawn explosion effect
	var ex_eff = EXPLOSION_EFF.instance()
	get_parent().add_child(ex_eff)
	ex_eff.global_position = self.global_position
	
	self.queue_free()

func is_killed_by_debris(player_proj) -> bool:
	return is_dead() and player_proj is PlayerProjectileDebris

func get_total_credit_drop() -> int:
	return int(credits_base + ceil(credits_base * (pow(lv - 1, 0.9) / 6)))

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_VisibilityNotifier2D_screen_exited() -> void:
	if destroy_outside_screen:
		self.queue_free()

func _on_Area2D_area_entered(area: Area2D) -> void:
	var area_owner = area.get_owner()
	
	if area_owner is PlayerProjectile:
		collide_with_player_projectile(area_owner)
	if area_owner is PlayerShip:
		collide_with_player_ship(area_owner)

func _on_EnemyCore_tree_exiting() -> void:
	_battleserver_change_total_enemy_count(-1)

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _init_exp_system() -> void:
	exp_system.current_level = lv
	exp_system.exp_drop_base = experience

func _spawn_debris() -> void:
	for i in debris_count:
		var deb = debris_obj.instance()
		get_parent().call_deferred("add_child", deb)
		deb.global_position = global_position
		deb.set_level_from_entity(self)
		deb.base_atk_bonus += debris_damage
		deb.update_stats()

func _spawn_main_currency() -> void:
	if rand_range(0, 1) > credits_drop_chance:
		return
	
	var splited_credits = Util_NumberSplit.isplit(get_total_credit_drop(), credits_drop_count, CREDIT_MULTIDROP_RAND_VALUE_FACTOR)
	for i in splited_credits:
		var pickups_main_curr := pickups_turret.spawn_main_currency()
		pickups_main_curr.main_currency_add = i

func _test_kill():
	if is_dead():
		kill()

func _battleserver_change_total_enemy_count(amount : int):
	if is_battleserver_countable:
		BattleServer.total_enemy_count += amount

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------




