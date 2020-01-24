# ResSuperpower
# Written by: First

extends ResItemEquip

class_name ResItemEquipSuperpower

"""
	Superpower is a special ability equipped on a ship. It can be
	activated to unleash a powerful ability.
	
	---
	
	Hits to charge: x The number of hits required to completely
	fill up superpower.
	
	Damage: x% The value of x is a percentage relative to the overall
	attack points of your ship. For example, if your ship has
	an attack power of 200 and the damage value of this superpower
	is 20%, the power of this superpower is 40.
	
	Description: Information about the superpower.
	
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

const DEFAULT_MAX_POWER_PTS = 9999

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (int) var hits_to_charge = 100

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

