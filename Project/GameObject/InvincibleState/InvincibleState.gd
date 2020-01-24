# InvincibleState
# Written by: First

extends Node

class_name InvincibleState

"""
	Enter desc here.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal started

signal stopped

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (float) var invinc_time = 1.0 setget set_invinc_time, get_invinc_time

export (bool) var autostart = false


onready var timer := $Timer as Timer setget ,get_timer

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	_test_autostart()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func start_invincibility(var custom_time : float = -1):
	_update_invinc_time(custom_time)
	timer.start()
	emit_signal("started")

func is_invincible() -> bool:
	return not timer.is_stopped()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Timer_timeout():
	emit_signal("stopped")

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _test_autostart():
	if autostart:
		start_invincibility()

func _update_invinc_time(custom_time : float) -> void:
	if custom_time == -1:
		timer.wait_time = invinc_time
	else:
		timer.wait_time = custom_time

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_invinc_time(val : float) -> void:
	invinc_time = val

func get_invinc_time() -> float:
	return invinc_time

func get_timer() -> Timer:
	return timer
