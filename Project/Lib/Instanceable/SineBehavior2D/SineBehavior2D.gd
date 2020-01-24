# Sine Behavior
# CR: Construct 2
# Written by: Okanar, First

extends Node

class_name SineBehavior2D

"""
	The Sine behavior can adjust an object's properties 
	(like its position, size or angle) back and forth 
	according to an oscillating sine wave. This can be used
	to create interesting visual effects. Despite the name,
	alternative wave functions such as 'Triangle' can also be
	created for different effects.
"""

#-------------------------------------------------
#      Constants
#-------------------------------------------------

enum MovementType {
	HORIZONTAL,
	VERTICAL,
	ANGLE,
	OPACITY,
}

enum ProcessType {
	IDLE,
	PHYSICS
}

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#The node you want to have this behavior applied.
export (NodePath) var root_node = "./.." setget set_root_node

#Enable behaviour at the beginning of the layout.
#If No, the behavior will have no effect until the Set active action is used.
export(bool) var active = true setget set_active, is_active

#The process how the object moves from a chosen behavior:
#
#- Idle: Update once per frame.
#
#- Physics: Update and sync with physics.
export(ProcessType) var process_mode = 0 setget set_process_mode

#Change the movement type of the behavior, e.g. from Horizontal to Vertical.
export(MovementType) var movement = 0

#The wave function used to calculate the movement.
export(Curve) var wave : Curve setget set_wave

#The duration, in seconds, of one complete back-and-forth cycle.
export(float) var period = 2 setget set_period

#A random number of seconds added to the period for each instance. This can
#help vary the appearance when a lot of instances are using the Sine behavior.
export(float, 0, 1) var period_random = 0

#The initial time in seconds through the cycle. For example, if the period is
#2 seconds and the period offset is 1 second, the sine behavior starts
#half way through a cycle.
export(float) var period_offset = 0

#A random number of seconds added to the period offset for each instance.
#This can help vary the appearance when a lot of instances are using the
#Sine behavior.
export(float, 0, 1) var period_offset_random = 0

#The maximum change in the object's position, size or angle. This is in
#pixels for position or size modes, or degrees for the angle mode.
export(float) var magnitude = 64 setget set_magnitude

#A random value to add to the magnitude for each instance.
#This can help vary the appearance when a lot of instances are using
#the Sine behavior.
export(float, 0, 1) var magnitude_random = 0

var _init_position : Vector2
var _current_cycle : float

#-------------------------------------------------
#       Notifications
#-------------------------------------------------

func _get_configuration_warning() -> String:
	var warning : PoolStringArray
	
	if not (get_node(root_node) is Node2D or get_node(root_node) is Control):
		warning.append("This node only works with a root node having 'position' property. Please assign a new root node.")
	if wave == null:
		warning.append("Wave property does not have any Curve2D assigned. Without this, specified root node will not work")
	
	return warning.join("\n")

func _ready() -> void:
	#Not allows running in editor
	if Engine.is_editor_hint():
		return
	
	var _fetched_root_node = get_node(root_node)
	
	if _fetched_root_node == null:
		return
	
	_init_position = _fetched_root_node.get_position()
	
	#Initialize period, period_offset, and magnitude random
	#by their respective random value
	period -= period * rand_range(0, period_random)
	period_offset -= period_offset * rand_range(0, period_offset_random)
	magnitude -= magnitude * rand_range(0, magnitude_random)
	
	_current_cycle += period_offset
	
	if wave == null:
		push_warning(str(self.get_path(), " Curve's property is not specified. No action was taken."))
	
	_update_root_node_position()

func _process(delta: float) -> void:
	#Not allows running in editor
	if Engine.is_editor_hint():
		return
	
	if process_mode == ProcessType.IDLE:
		_do_process(delta)

func _physics_process(delta: float) -> void:
	#Not allows running in editor
	if Engine.is_editor_hint():
		return
	
	if process_mode == ProcessType.PHYSICS:
		_do_process(delta)




#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _do_process(delta: float) -> void:
	if not is_active():
		return
	
	_update_root_node_position()
	
	_current_cycle += delta
	if _current_cycle > period:
		_current_cycle -= period

func _update_root_node_position():
	if wave == null:
		return
	var _fetched_root_node = get_node(root_node)
	if _fetched_root_node == null:
		return
	var calculated_interpolate_wave : float = wave.interpolate_baked(_current_cycle / period) * magnitude
	
	if _fetched_root_node is Node2D:
		if movement == MovementType.HORIZONTAL:
			_fetched_root_node.position.x = _init_position.x + calculated_interpolate_wave
		if movement == MovementType.VERTICAL:
			_fetched_root_node.position.y = _init_position.y + calculated_interpolate_wave
		if movement == MovementType.ANGLE:
			_fetched_root_node.rotation_degrees = calculated_interpolate_wave
		if movement == MovementType.OPACITY:
			_fetched_root_node.modulate.a8 = calculated_interpolate_wave
	if _fetched_root_node is Control:
		if movement == MovementType.HORIZONTAL:
			_fetched_root_node.rect_position.x = _init_position.x + calculated_interpolate_wave
		if movement == MovementType.VERTICAL:
			_fetched_root_node.rect_position.y = _init_position.y + calculated_interpolate_wave
		if movement == MovementType.ANGLE:
			_fetched_root_node.rect_rotation = calculated_interpolate_wave
		if movement == MovementType.OPACITY:
			_fetched_root_node.modulate.a8 = calculated_interpolate_wave



#-------------------------------------------------
#       Setters & Getters
#-------------------------------------------------

func set_root_node(var value : NodePath) -> void:
	root_node = value
	emit_signal("script_changed")

func set_active(var value : bool) -> void:
	active = value

func set_process_mode(var value : int) -> void:
	process_mode = value

func set_cycle_position(var value : float) -> void:
	_current_cycle = value

func set_magnitude(var value : float) -> void:
	magnitude = value

func set_movement(var value : int) -> void:
	movement = value

func set_period(var value : float) -> void:
	period = value

func set_wave(var resource : Curve) -> void:
	wave = resource
	emit_signal("script_changed")

func is_active() -> bool:
	return active
