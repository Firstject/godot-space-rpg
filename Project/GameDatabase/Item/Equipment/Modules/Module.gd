# ResModule
# Written by: First

tool
extends ResItemEquip

class_name ResItemEquipModule

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

const SUB_EQUIP_UPGRADES_NAME = "ResItEq"

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (Array, Resource) var upgrade_change_equips setget _set_upgrade_change_equips, get_upgrade_change_equips

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

func get_current_equip(lv : int) -> ResItemEquip:
	return upgrade_change_equips[lv]

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func _set_upgrade_change_equips(val : Array) -> void:
	upgrade_change_equips = val
	
	if not upgrade_change_equips.empty() and upgrade_change_equips.back() == null:
		var new_equip = ResItemEquip.new()
		new_equip.set_name(SUB_EQUIP_UPGRADES_NAME)
		
		upgrade_change_equips[upgrade_change_equips.size() - 1] = new_equip

func get_upgrade_change_equips() -> Array:
	return upgrade_change_equips
