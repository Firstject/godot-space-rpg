# 8DirectionBehavior
# Written by: First

extends Node

class_name EightDirectionBehavior

"""
	The 8 Direction behavior allows an object to be moved up, down,
	left, right and on diagonals, controlled by the arrow keys
	by default. It is often useful for controlling the player
	in a top-down view game.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

enum DirectionType {
	LEFT_AND_RIGHT,
	UP_AND_DOWN
	EIGHT_DIRECTIONS
}

enum ProcessType {IDLE, PHYSICS}

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#The node you want to have this behavior applied.
export (NodePath) var root_node = "./.." setget set_root_node, get_root_node

#The process how property sets from a chosen behavior:
#
#- Idle: Update once per frame.
#
#- Physics: Update and sync with physics.
export (ProcessType) var process_mode = 0

#If false, the behavior is in disabled state and won't do anything.
export (bool) var active = true

#The speed the object can travel at in any direction,
#in pixels per second.
export (float) var speed = 300.0

#Set how many directions the movement can move in. By default it is
#8 Directions, allowing movement on diagonals. Up & down or
#Left & right only allows movement along a single axis.
export (DirectionType) var directions = DirectionType.EIGHT_DIRECTIONS

#Default action key for a controlled movement of move left.
export (String) var default_control_left = "ui_left"

#Default action key for a controlled movement of move right.
export (String) var default_control_right = "ui_right"

#Default action key for a controlled movement of move up.
export (String) var default_control_up = "ui_up"

#Default action key for a controlled movement of move down.
export (String) var default_control_down = "ui_down"

#Set whether input is being ignored. If input is ignored, pressing
#any of the control keys has no effect. However, unlike disabling
#the behavior, the object can continue to move.
export (bool) var ignore_inputs = true

#Property to be set. Note that the property name must be type of
#Vector2. Otherwise, this node will not work.
export (String) var vector_property_to_set = "position"


var velocity : Vector2

var moving_direction : Vector2

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _process(delta: float) -> void:
	if process_mode == ProcessType.IDLE:
		_do_process(delta)

func _physics_process(delta: float) -> void:
	if process_mode == ProcessType.PHYSICS:
		_do_process(delta)

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

func _do_process(delta : float):
	if not active:
		return
	
	var _fetched_root_node := get_node(root_node)
	moving_direction = Vector2.ZERO
	
	_set_moving_direction()
	
	if moving_direction.length() > 0:
		moving_direction = moving_direction.normalized()
	
	velocity = moving_direction * speed * delta
	
	if vector_property_to_set in _fetched_root_node:
		_fetched_root_node.set(vector_property_to_set, _fetched_root_node.get(vector_property_to_set) + velocity)

func _set_moving_direction() -> void:
	if not ignore_inputs:
		if Input.is_action_pressed(default_control_left):
			if not directions == DirectionType.UP_AND_DOWN:
				moving_direction.x -= 1
		if Input.is_action_pressed(default_control_right):
			if not directions == DirectionType.UP_AND_DOWN:
				moving_direction.x += 1
		if Input.is_action_pressed(default_control_up):
			if not directions == DirectionType.LEFT_AND_RIGHT:
				moving_direction.y -= 1
		if Input.is_action_pressed(default_control_down):
			if not directions == DirectionType.LEFT_AND_RIGHT:
				moving_direction.y += 1

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_root_node(val : NodePath) -> void:
	root_node = val

func get_root_node() -> NodePath:
	return root_node
