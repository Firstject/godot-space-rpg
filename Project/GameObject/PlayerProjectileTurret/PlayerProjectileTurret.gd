# PlayerProjectileTurret
# Written by: First

extends Node2D

class_name PlayerProjectileTurret

"""
	Base Node2D class that should be attached to the player's
	node. This can spawn a player projectile, which
	provides easier way to set up your projectile object.
	
	Set up property 'player_proj_obj' where the type of that object is
	inherited from PlayerProjectile. Then whenever you need the
	player's projectile object to spawn, you can call a method
	spawn_player_proj() to make it appear in the scene tree.
	
	A spawned projectile will have its level and stats inherited from
	an entity source if you pass the first parameter through
	spawn_player_proj() method.
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

enum SpawnTarget {
	SPRITE_CY_NODE,
	PARENT_OF_OWNER,
	OWNER,
	PARENT
}

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#If root_node is not specified, the owner of this node will be used
#as a reference instead.
export (NodePath) var root_node : NodePath = "./.."

export (PackedScene) var player_projectile_obj

#Offset to spawn from a point in Vector2D.
export (Vector2) var spawn_offset

export (SpawnTarget) var spawn_target

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

func spawn_player_proj(var entity_source, var custom_player_proj_obj : PackedScene = player_projectile_obj) -> PlayerProjectile:
	return _do_spawn_player_proj(entity_source, player_projectile_obj)


#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _do_spawn_player_proj(var entity_source : Entity, var custom_player_proj_obj : PackedScene):
	if custom_player_proj_obj == null:
		return null
	if not custom_player_proj_obj.can_instance():
		push_error(
			str(
				self,
				custom_player_proj_obj,
				" can't be instanced. No player's projectile were spawned."
			)
		)
		return null
	
	var inst_proj_obj = custom_player_proj_obj.instance()
	
	match spawn_target:
		SpawnTarget.SPRITE_CY_NODE:
			var sp_cy_node = get_tree().get_nodes_in_group("SpriteCycling")[0]
			sp_cy_node.get_parent().add_child(inst_proj_obj)
		SpawnTarget.PARENT_OF_OWNER:
			get_owner().get_parent().add_child(inst_proj_obj)
		SpawnTarget.OWNER:
			get_owner().add_child(inst_proj_obj)
		SpawnTarget.PARENT:
			get_parent().add_child(inst_proj_obj)
	
	#Set position relative to this node.
	inst_proj_obj.global_position = self.global_position + spawn_offset
	
	#Set level from entity source
	if entity_source != null:
		if inst_proj_obj is Entity:
			inst_proj_obj.set_level_from_entity(entity_source)
			inst_proj_obj.clear_bonus_stats()
			inst_proj_obj.add_bonuses_from_entity(entity_source)
	
	return inst_proj_obj



#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

