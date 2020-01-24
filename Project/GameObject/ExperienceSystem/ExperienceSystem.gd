# ExperienceSystem
# Written by: First

extends Node

class_name ExperienceSystem

"""
	Enter desc here.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal level_up

signal max_level_reached

signal gained_exp(amount)

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (int) var exp_drop_base = 40

export (int) var max_level = 300

export (float) var required_exp_base = 35

export (float) var growth_rate = 1.3

export (float) var growth_rate_expo = 3.2

var current_level : int = 1 setget set_current_level

var current_exp : int = 0

var current_next_exp : int setget set_current_next_exp

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	update_required_exp()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func gain_exp(exp_value : int) -> void:
	current_exp += exp_value
	
	if _has_reached_next_exp():
		level_up()
	
	emit_signal("gained_exp", exp_value)

func level_up() -> void:
	#Increase level
	current_level += 1
	
	AudioCenter.level_up.play()
	
	update_required_exp()
	
	if is_at_max_level():
		emit_signal("max_level_reached")
		return
	
	#Chain leveling
	if _has_reached_next_exp():
		level_up() #Recursive call
	else:
		emit_signal("level_up")
	

func multiply_exp_drop(multiplier : float) -> void:
	exp_drop_base *= multiplier

func is_at_max_level() -> bool:
	return current_level == max_level

func update_required_exp():
	current_next_exp = get_required_exp(current_level)

func get_exp_drop() -> int:
	return int(ceil(exp_drop_base * (pow(current_level, 0.9) / 6)))

func get_required_exp(lvl : int = current_level) -> int:
	return int(ceil(growth_rate * pow(lvl, growth_rate_expo) + (required_exp_base * lvl)))

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _has_reached_next_exp() -> bool:
	return current_exp >= current_next_exp

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_current_level(val : int) -> void:
	current_level = val
	update_required_exp()

func set_current_next_exp(val : int) -> void:
	current_next_exp = val
