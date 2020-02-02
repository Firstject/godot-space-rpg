# EnemyTurret
# Written by: First

extends Node2D

class_name EnemyTurret

"""
	Base Node2D class that should be attached to the enemy's
	node. This can spawn either an enemy or a projectile, which
	provides easier way to set up your favorite enemy objects.
	
	Set up property 'enemy_obj' where the type of that object is
	inherited from EnemyShip. Then whenever you need the
	enemy object to spawn, you can call a method spawn_enemy()
	to make it appear in the scene tree.
	
	A spawned enemy will have its level and stats inherited from
	an entity source if you pass the first parameter through
	spawn_enemy() method.
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

#If root_node is not specified, the owner of this node will be used
#as a reference instead.
export (NodePath) var root_node : NodePath = "./.."

#Enemy object to spawn when either spawn_enemy() or spawn_enemy_proj()
#function is called. Should inherits EnemyCore or unexpected
#things will happen.
export (PackedScene) var enemy_obj

#Offset to spawn from a point in Vector2D.
export (Vector2) var spawn_offset

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

#Spawn an enemy object that defined in an export variable 'enemy_obj'
#and returns the spawned object.
#It's level will also be set, relative to the entity source that
#should be included in the first parameter.
#An optional parameter can be also passed for a custom enemy in case
#you don't want to change 'enemy-obj' property.
func spawn_enemy(var entity_source, var custom_enemy_obj : PackedScene = enemy_obj) -> EnemyCore:
	return _do_spawn_enemy(entity_source, custom_enemy_obj)

#Spawn an enemy object that defined in an export variable 'enemy_obj'
#and returns the spawned object.
#It's level will also be set, relative to the entity source that
#should be included in the first parameter.
#An optional parameter can be also passed for a custom enemy in case
#you don't want to change 'enemy-obj' property.
#
#**This method is the same as `spawn_enemy()`, but with a different
#return value.**
func spawn_enemy_proj(var entity_source, var custom_enemy_obj : PackedScene = enemy_obj) -> EnemyProjectileCore:
	return _do_spawn_enemy(entity_source, custom_enemy_obj)



#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _do_spawn_enemy(var entity_source : Entity, var custom_enemy_obj : PackedScene):
	if custom_enemy_obj == null:
		return null
	if not custom_enemy_obj.can_instance():
		push_error(
			str(
				self,
				custom_enemy_obj,
				" can't be instanced. No enemy were spawned."
			)
		)
		return null
	
	var inst_enemy_obj = custom_enemy_obj.instance()
	
	#Add instanced object to the parent node of a specified root node.
	#If root_node is not specified, the owner of this node will be used
	#as a reference instead.
	var parent_root_node : Node
	if not root_node.is_empty():
		parent_root_node = get_node(root_node)
	else:
		parent_root_node = get_owner()
	
	parent_root_node.get_parent().add_child(inst_enemy_obj)
	
	#Set position relative to this node.
	inst_enemy_obj.global_position = self.global_position + spawn_offset
	
	#Set level from entity source
	if entity_source != null:
		if inst_enemy_obj is Entity:
			inst_enemy_obj.set_level_from_entity(entity_source)
			inst_enemy_obj.clear_bonus_stats()
			inst_enemy_obj.add_bonuses_from_entity(entity_source)
	
	return inst_enemy_obj



#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

