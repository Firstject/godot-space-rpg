# PlayerShield
# Written by: First

extends PlayerEquipmentCore

class_name PlayerShieldCore

"""
	The shield starts at 100% power at the beginning of the game. When
	the ship takes damage, the power decreases by damage value (after
	damage calculation of the ship's defense value). Until it hits
	zero percentage, the ship will able to lose hp. Although when taking
	damage and the shield's power goes down to 0%, the remainder of
	the damage value can still reduce ship's hp. After taking damage
	the shield generation time will be paused for a short while
	regardless of the remaining shield's power.
	
	The shield only works when colliding with the enemy's projectile.
	Colliding with the enemy's ship will not reduce the shield's power.
	However, a passive ability that blocks collision will be able to
	absorb damage from colliding enemies.
	
	Taking damage from the projectiles will not trigger the invincibility
	time frame. Getting hit by multiple projectiles may cause
	the shield's power to rapidly dropped and may eventually take damage.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal absorbed(dmg)

signal depleted

signal power_updated

#-------------------------------------------------
#      Constants
#-------------------------------------------------

const MAX_SHIELD_POWER_PERCENT = 1.0
const MIN_SHIELD_POWER_PERCENT = 0.0

#-------------------------------------------------
#      Properties
#-------------------------------------------------

onready var regen_timer = $RegenerateTimer as Timer
onready var interrupt_recover_timer = $InterruptRecoverTimer as Timer


var current_max_power : int = 50
var current_power_percent : float = 1.00
var previous_absorbed_damage : int setget set_previous_absorbed_damage

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	_init_shield_data()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#Start calculate damage absorption for the player and reduce the shield power.
#Return reduced damage output. If the returned value is zero, then
#the shield already takes full damage. Otherwise, the shield is depleted.
#Calling this method will interrupt the shield power recovery and cause
#the following signals to be emitted: 'absorbed', and 'depleted'.
func absorb(source_final_damage : int) -> int:
	#If the damage is at zero or below, then the shield should not get
	#interrupted.
	if source_final_damage <= 0:
		emit_signal("absorbed", 0)
		set_previous_absorbed_damage(0)
		return 0
	
	#Interrupt the shield's recovery.
	interrupt()
	
	#Calculate total damage absorbed
	var _remaining_shield_power = get_remaining_shield_power() - source_final_damage
	var absorbed_damage : int
	if _remaining_shield_power < 0: #Shield depleted to 0%
		absorbed_damage = source_final_damage - int(abs(_remaining_shield_power))
		_remaining_shield_power = 0
		set_previous_absorbed_damage(absorbed_damage)
		emit_signal("absorbed", absorbed_damage)
		emit_signal("depleted")
	else: #Shield took full damage; player ship took no damage.
		absorbed_damage = source_final_damage
		set_previous_absorbed_damage(absorbed_damage)
		emit_signal("absorbed", absorbed_damage)
	
	#Reduce shield power percentage
	var total_percent_shield_lost = source_final_damage / float(current_max_power)
	var percent_shield_result = current_power_percent - total_percent_shield_lost
	current_power_percent = percent_shield_result
	_normalize_shield_power()
	
	#Acknowledge that the shield power value is updated
	emit_signal("power_updated")
	
	return source_final_damage - absorbed_damage

func restore_power():
	if has_shield_database():
		current_power_percent += get_shield_database().recovery
	
	_normalize_shield_power()
	
	#Acknowledge that the shield power value is updated
	emit_signal("power_updated")

func interrupt():
	if has_shield_database():
		if not get_shield_database().can_interrupt:
			return
	
	regen_timer.stop()
	interrupt_recover_timer.start()

func update_max_power(new_power : int):
	if has_shield_database():
		current_max_power = new_power * get_shield_database().strength
	else:
		push_warning(
			str(
				self.get_path(),
				" updating shield power without database!"
			)
		)
		current_max_power = new_power

func get_remaining_shield_power() -> int:
	return int(current_max_power * current_power_percent)

func has_shield_database() -> bool:
	return equip_database != null

func is_power_depleted() -> bool:
	return current_power_percent <= 0

func get_shield_database() -> ResItemEquipShield:
	return equip_database as ResItemEquipShield

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_InterruptRecoverTimer_timeout() -> void:
	regen_timer.start()

func _on_RegenerateTimer_timeout() -> void:
	restore_power()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _normalize_shield_power() -> void:
	current_power_percent = stepify(
		clamp(
			current_power_percent,
			MIN_SHIELD_POWER_PERCENT,
			MAX_SHIELD_POWER_PERCENT
		), 0.01
	)

func _init_shield_data() -> void:
	if has_shield_database():
		#Set regen time
		regen_timer.set_wait_time(get_shield_database().recover_interval)
		interrupt_recover_timer.set_wait_time(get_shield_database().interrupt_recovery_timer)

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_previous_absorbed_damage(val : int) -> void:
	previous_absorbed_damage = val
