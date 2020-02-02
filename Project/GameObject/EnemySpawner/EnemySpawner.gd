# EnemySpawner
# Written by: First

extends Node2D

class_name EnemySpawner

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

enum SpawnToNode {
	SPRITE_CYCLING,
	PARENT
}

const DEFAULT_SPAWN_TO_NODE_LOCATION = SpawnToNode.SPRITE_CYCLING

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export var enemy_to_spawn : PackedScene

#Y-offset will only be used for spawning check
#Usually the position of the top-left screen is at (0, 0)
export var spawn_offset := Vector2(0, -16)

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _process(delta: float) -> void:
	_test_spawn()

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

func _test_spawn():
	if global_position.y > spawn_offset.y:
		_spawn()
		queue_free()

func _spawn() -> void:
	if enemy_to_spawn == null:
		push_warning(str(self.get_path(), " Can't spawn empty enemy!"))
		return
	
	var enmy = enemy_to_spawn.instance() as EnemyCore
	enmy.global_position = self.global_position
	enmy.lv = LevelServer.current_enemy_lv
	
	match DEFAULT_SPAWN_TO_NODE_LOCATION:
		SpawnToNode.PARENT:
			get_parent().add_child(enmy)
		SpawnToNode.SPRITE_CYCLING:
			var sp_cy_node = get_tree().get_nodes_in_group("SpriteCycling")[0]
			sp_cy_node.get_parent().add_child(enmy)
	
	
	
	

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

