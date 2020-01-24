# DamagePopupTurret
# Written by: First

extends Node2D

class_name DamagePopupTurret

"""
	For use in Galax Hero project only!
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

const DMG_POPUP = preload("res://GameObject/DamagePopup/DamagePopup.tscn")

const MAX_STACK_TIME = 0.12

#-------------------------------------------------
#      Properties
#-------------------------------------------------

var last_dmg_popup_obj : DamagePopup

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	$StackTimer.set_wait_time(MAX_STACK_TIME)

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func spawn_damage_popup(dmg : int, type : int):
	if _can_stack_previous(type):
		_stack_previous(dmg)
		last_dmg_popup_obj.start()
		
		#Make the dmg popup obj move to this turret
		last_dmg_popup_obj.global_position = global_position
	else:
		var dp = DMG_POPUP.instance()
		get_owner().get_parent().add_child(dp)
		dp.global_position = global_position
		
		dp.set_number(dmg)
		dp.set_dmg_type(type)
		dp.start()
		
		#Save current dmg popup object for stacking dmg later.
		#Only works if it is not a critical damage.
		if not DamagePopup.is_critical_type(type):
			last_dmg_popup_obj = dp
	
	$StackTimer.start()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _can_stack_previous(dmg_popup_type : int):
	return not(
		$StackTimer.is_stopped() or
		last_dmg_popup_obj == null or
		DamagePopup.is_critical_type(dmg_popup_type) or
		not is_instance_valid(last_dmg_popup_obj) or
		not last_dmg_popup_obj is DamagePopup
	)

func _stack_previous(dmg : int):
	last_dmg_popup_obj.number += dmg

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------
