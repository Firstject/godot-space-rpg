# Entity
# Written by: First

extends Node2D

class_name Entity

"""
	Enter desc here.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal dead(killer_entity)

signal took_damage()

signal attacked(target_entity, dmg, is_crit)

signal healed(dmg)

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (int) var lv = 1
export (float) var base_hp = 40
export (float) var base_atk = 15
export (float) var base_def = 10
export (float, 0, 1) var crit_rate = 0.01
export (float) var crit_damage_rate = 2.0
export (bool) var can_hit = true
export (bool) var can_damage = true
export (bool) var is_targetable = true

var hp : float
var atk : float
var def : float
var max_hp : float
var base_hp_bonus : float
var base_atk_bonus : float
var base_def_bonus : float
var crit_rate_bonus : float
var crit_damage_rate_bonus : float

var previous_attacker : Entity setget set_previous_attacker
var previous_damage_taken : int setget set_previous_damage_taken
var previous_is_crit_taken : bool setget set_previous_is_crit_taken
var dead : bool = false setget set_dead, is_dead

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	_parent_ready()
	_init_base_stats()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

func _parent_ready():
	pass

func _dead():
	pass

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#Return final calculated damage as int value.
func take_damage(total_damage : int) -> void:
	self.hp -= total_damage
	
	emit_signal("took_damage")
	_death_check()

func can_be_damaged_by(attacker_entity : Entity) -> bool:
	if not can_hit:
		return false
	if not attacker_entity.can_damage:
		return false
	
	return true

func calculate_take_damage_from_entity(attacker_entity : Entity) -> int:
	var total_damage : float
	var is_critical = rand_range(0, 1) < attacker_entity.crit_rate + attacker_entity.crit_rate_bonus
	
	total_damage += attacker_entity.atk
	total_damage *= rand_range(0.9, 1.1)
	total_damage -= self.def * 0.25
	total_damage = int(total_damage)
	if is_critical:
		total_damage *= attacker_entity.crit_damage_rate + attacker_entity.crit_damage_rate_bonus
	total_damage = clamp(total_damage, 0, 99999)
	
	set_previous_attacker(attacker_entity)
	set_previous_damage_taken(total_damage)
	set_previous_is_crit_taken(is_critical)
	
	return int(total_damage)

func heal(amount : float) -> int:
	var total_damage
	total_damage = amount
	
	self.hp += int(total_damage)
	
	return int(total_damage)

#Used for adding bonus and then recalculate stats
func clear_bonus_stats() -> void:
	base_hp_bonus = 0
	base_atk_bonus = 0
	base_def_bonus = 0
	crit_rate_bonus = 0
	crit_damage_rate_bonus = 0
	
	update_stats()

func add_bonuses_from_entity(entity_source : Entity):
	base_hp_bonus += entity_source.base_hp + entity_source.base_hp_bonus
	base_atk_bonus += entity_source.base_atk + entity_source.base_atk_bonus
	base_def_bonus += entity_source.base_def + entity_source.base_def_bonus
	crit_rate_bonus += entity_source.crit_rate + entity_source.crit_rate_bonus
	crit_damage_rate_bonus += entity_source.crit_damage_rate + entity_source.crit_damage_rate_bonus
	
	update_stats()

func update_stats():
	var _prev_max_hp = max_hp
	
	self.max_hp = (base_hp + base_hp_bonus) + round(pow(lv - 1, 1.5) * (base_hp / 30.0))
	self.atk = (base_atk + base_atk_bonus) + round(pow(lv - 1, 1.5) * ((base_atk + base_atk_bonus) / 30.0))
	self.def = (base_def + base_def_bonus) + round(pow(lv - 1, 1.5) * ((base_def + base_def_bonus) / 30.0))
	
	_adjust_hp_by_max_hp(_prev_max_hp)

func get_hit_points_percentage() -> float:
	if max_hp == 0:
		return 0.0 #Avoid divide by zero.
	return hp / max_hp

func set_level_from_entity(var entity_source : Entity) -> void:
	self.lv = entity_source.lv
	update_stats()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _init_base_stats():
	
	update_stats()
	
	self.hp = max_hp

func _adjust_hp_by_max_hp(prev_max_hp : int):
	if prev_max_hp == 0: #Avoid division by zero
		return
	
	var percent_changed : float = max_hp / prev_max_hp
	
	hp = round(hp * percent_changed)

func _death_check():
	if hp <= 0 and not is_dead():
		set_dead(true)
		emit_signal("dead")
		_dead()

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_lv(val : int) -> void:
	lv = val
	update_stats()

func set_previous_attacker(val : Entity) -> void:
	previous_attacker = val

func set_previous_damage_taken(val : int) -> void:
	previous_damage_taken = val

func set_previous_is_crit_taken(val : bool) -> void:
	previous_is_crit_taken = val

func set_dead(val : bool) -> void:
	dead = val

func is_dead() -> bool:
	return dead
