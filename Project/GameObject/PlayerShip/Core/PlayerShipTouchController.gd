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

enum ControlMode {
	TAP_POSITION,
	RELATIVE
}

const MOVE_SPEED = 480

const TOUCH_OFFSET = Vector2(0, -32)

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (NodePath) var target_node2d

export (bool) var active = true setget set_active

export (ControlMode) var control_mode = ControlMode.RELATIVE

export (float, 0.2, 3.0) var drag_rel_sensitivity = 1.2


var _fetched_node2d : Node2D
var current_position : Vector2 setget set_current_position
var _is_touching : bool = false

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready():
	LevelGUI.playfield_input.connect("gui_input", self, "_on_gui_input_node")
	
	_fetched_node2d = get_node(target_node2d)
	_update_drag_rel_pos()

func _process(delta):
	if not active:
		return
	
	_move_player(delta)
	
	if _fetched_node2d == null:
		return
	if _fetched_node2d.global_position.x < 0:
		_fetched_node2d.global_position.x = 0
	if _fetched_node2d.global_position.x > 224:
		_fetched_node2d.global_position.x = 224
	if _fetched_node2d.global_position.y < 0:
		_fetched_node2d.global_position.y = 0
	if _fetched_node2d.global_position.y > get_viewport().get_visible_rect().size.y:
		_fetched_node2d.global_position.y = get_viewport().get_visible_rect().size.y
	
	if current_position.x < 0:
		current_position.x = 0
	if current_position.x > 224:
		current_position.x = 224
	if current_position.y < 0:
		current_position.y = 0
	if current_position.y > get_viewport().get_visible_rect().size.y:
		current_position.y = get_viewport().get_visible_rect().size.y

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
	match control_mode:
		ControlMode.TAP_POSITION:
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
		ControlMode.RELATIVE:
			if event is InputEventScreenDrag:
				current_position += event.relative * drag_rel_sensitivity
				_is_touching = true
				$DragIdleTimer.start()
				return

func _on_TouchIdleTimer_timeout():
	_is_touching = false

func _on_DragIdleTimer_timeout():
	_is_touching = false
	_update_drag_rel_pos()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _move_player(delta : float):
	if not _is_touching:
		return
	if current_position == Vector2.ZERO:
		return
	
	_fetched_node2d.position = _fetched_node2d.position.move_toward(current_position, MOVE_SPEED * delta)

func _update_drag_rel_pos():
	if _fetched_node2d == null:
		return
	
	current_position = _fetched_node2d.position

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_active(val : bool) -> void:
	_update_drag_rel_pos()
	active = val

func set_current_position(val : Vector2) -> void:
	current_position = val

