# PickupsTurret
# Written by: First

extends Node2D

class_name PickupsTurret

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

const PICKUPS_MAIN_CURR_OBJ = preload("res://GameObject/Pickups/PickupsMainCurrency.tscn")
const PICKUPS_ITEM_OBJ = preload("res://GameObject/Pickups/PickupsItem.tscn")

#-------------------------------------------------
#      Properties
#-------------------------------------------------

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

func spawn_main_currency() -> Pickups:
	var pickups_obj = PICKUPS_MAIN_CURR_OBJ.instance()
	
	get_owner().get_parent().call_deferred("add_child", pickups_obj)
	pickups_obj.global_position = global_position
	
	return pickups_obj

func spawn_item():
	pass

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

