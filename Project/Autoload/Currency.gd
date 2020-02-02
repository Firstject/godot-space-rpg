# Currency
# Written by: First

extends Node

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

const MAIN_CURRENCY_NAME := "Credits"

const RARE_CURRENCY_NAME := "Galax Star"

#-------------------------------------------------
#      Properties
#-------------------------------------------------

var total_main_currency : int setget set_total_main_currency

var total_rare_currency : int setget set_total_rare_currency

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

func add_main_currency(amount : int):
	total_main_currency += amount

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_total_main_currency(val : int) -> void:
	total_main_currency = val
	GameServer.emit_signal("currency_updated")

func set_total_rare_currency(val : int) -> void:
	total_rare_currency = val
	GameServer.emit_signal("currency_updated")
