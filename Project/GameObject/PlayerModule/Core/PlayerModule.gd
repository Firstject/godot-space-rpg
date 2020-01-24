# PlayerModule
# Written by: First

extends PlayerEquipmentCore

class_name PlayerModule

"""
	PlayerModule is the equipment that can be installed in the player
	ship. The module acts like a regular equipment that provides small
	stats boost and bonus effects to your ship.
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

var current_module_lv = 1

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

func get_current_sub_equip() -> ResItemEquip:
	if not has_module_database():
		return null
	
	return get_module_database().get_upgrade_change_equips()[current_module_lv - 1]

func has_module_database() -> bool:
	return equip_database != null

func get_module_database() -> ResItemEquipModule:
	return equip_database as ResItemEquipModule

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------
