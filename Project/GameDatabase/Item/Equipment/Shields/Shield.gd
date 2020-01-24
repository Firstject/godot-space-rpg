# ResShield
# Written by: First

extends ResItemEquip

class_name ResItemEquipShield

"""
	Shield is the equipment that protects the damage from the enemy's
	projectile. It absorbs damage first before the , then loses
	its power. The shield regenerates its power over time.
	
	---
	
	Shield Strength: x% - Number of x adds up value to the shield's power
	(how many damage value to absorb). The shield's power depends on
	the ship's . For example, if the ship has 50 hp in total and
	equipped a shield with 20% strength, the shield can absorb 10 damage.
	
	Recover/Sec: x% - Number of x restores the shield's power every 
	seconds. Max power is at 100%.
	
	Special Ability - Grants a passive ability to the ship when equipped.
	
	NOTE: The most up to date version of the info can be found in Stackedit.
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

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (float) var strength = 0.10

export (float) var recovery = 0.01

export (float) var recover_interval = 1.0

export (float) var interrupt_recovery_timer = 2.0

export (bool) var can_interrupt = true

export (bool) var block_collisions = false

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

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

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

