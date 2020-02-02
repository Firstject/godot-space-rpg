# BattleServer
# Written by: First

extends Node

"""
	BattleServer emits signal from the events in the game field.
	
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal player_dead(player_obj)

signal player_took_damage(player_obj)

signal player_superpower_filled()

signal player_superpower_comsumed()

signal enemy_hit(enemy_entity)

signal enemy_hit_by_player_proj(enemy_entity)

signal enemy_killed(enemy_entity)

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#Automatically set by EnemyCore. Do not set this manually!
var total_enemy_count : int = 0

#Automatically set by Pickups. Do not set this manually!
var total_pickups_count : int = 0

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

func reset_all_counters():
	total_enemy_count = 0
	total_pickups_count = 0

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

