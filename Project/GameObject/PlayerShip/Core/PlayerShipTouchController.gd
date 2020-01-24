# PlayerShipTouchController
# Written by: First

extends Node

#class_name optional

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

const MOVE_SPEED = 480

const TOUCH_OFFSET = Vector2(0, -32)

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (NodePath) var target_node2d

export (bool) var active = true setget set_active


var _fetched_node2d : Node2D
var current_position : Vector2 setget set_current_position
var _is_touching : bool = false

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	LevelGUI.playfield_input.connect("gui_input", self, "_on_gui_input_node")
	
	_fetched_node2d = get_node(target_node2d)

func _process(delta):
	if not active:
		return
	
	_move_player(delta)

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

func _on_gui_input_node(event : InputEvent):
	if event is InputEventScreenTouch:
		set_current_position(event.position + TOUCH_OFFSET)
		_is_touching = true
		$TouchIdleTimer.start()
		return
	if event is InputEventScreenDrag:
		set_current_position(event.position + TOUCH_OFFSET)
		_is_touching = true
		$TouchIdleTimer.start()
		return

func _on_TouchIdleTimer_timeout():
	_is_touching = false

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _move_player(delta : float):
	if not _is_touching:
		return
	if current_position == Vector2.ZERO:
		return
	
	_fetched_node2d.position = _fetched_node2d.position.move_toward(current_position, MOVE_SPEED * delta)

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_active(val : bool) -> void:
	active = val

func set_current_position(val : Vector2) -> void:
	current_position = val

