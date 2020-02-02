# Shake Behavior
# Written by: First

tool #For configure warnings
extends Node

class_name ShakeBehavior

"""
	A behavior node that simulates both Node2D and Control node
	with the ability to shake on their position. Useful for making
	a hit effect such as when taking damage. Supports changing
	the node's property e.g. offset.
	
	The duration of the shake can be set when the shake effect should
	stop. You can also set this to infinity and stop the effect at
	any time.
	
	Magnitude can also be set to measure for the shake. A shake
	pattern (let's say making the entire shake process slowly decays
	or constants) can be customized through property `shake_curve`.
	
	Additionally, the ability to shake the camera and sprite is also
	supported. You can set the property of `vector_property_to_set`
	to `offset` (which is Vector2) directly without having to add
	a Node2D or Control to the parent node as a placeholder.
"""

#-------------------------------------------------
#      Classes
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#Emits when the shake process is completely finished.
signal shake_finished()

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#The process how property sets from a chosen behavior:
#
#- Idle: Update once per frame.
#
#- Physics: Update and sync with physics.
enum PROCESS_TYPE {
	IDLE,
	PHYSICS
}

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
export (PROCESS_TYPE) var process_mode = 0

#When true, it automatically starts.
#Works best when `infinite_duration` is on.
export (bool) var initial_active = false

#Time in seconds when the shake effect should stops.
export (float) var shake_duration = 0.3 setget set_shake_duration, get_shake_duration

#The strength of the shake, in pixels.
export (float) var shake_magnitude = 8 setget set_shake_magnitude, get_shake_magnitude

#Number of complete cycles for each shakes. Ex: a value of 30 will
#change its position 30 times during in-game 1 second.
export (float) var shake_frequency = 60 setget set_shake_frequency, get_shake_frequency

#If true, it shakes indefinitely.
export (bool) var infinite_duration = false

#A curve that scales the shaking magnitude.
export (Curve) var shake_curve : Curve setget set_curve, get_shake_curve

#A shake offset. Default value is `Vector2(0, 0)`.
export (Vector2) var shake_offset setget set_shake_offset, get_shake_offset

#Property to be set. Note that the property name must be type of
#Vector2. Otherwise, this node will not work.
export (String) var vector_property_to_set = "position"

#Initial shake duration since last method shake() called.
var last_total_shake_duration : float

#Initial Shake magnitude since last method shake() called.
var last_shake_magnitude : float

#Remaining shake duration in seconds.
var remaining_shake_duration : float

#Statement will be true if current shaking process is infinite.
var is_current_infinite : float

#Delta time passed since last method shake() called.
var current_delta_passed : float

#Frequency round time for a complete cycle
var current_frequency_round_time : float

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	if initial_active:
		start_shake(true)

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): #We want this to works only in-game.
		return
	
	if process_mode == PROCESS_TYPE.IDLE:
		_do_process(delta)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): #We want this to works only in-game.
		return
	
	if process_mode == PROCESS_TYPE.PHYSICS:
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

#Start shaking process.
#If there's already ongoing shaking process that has longer time,
#the function will not work. However, you can pass an optional
#boolean to bypass this.
func start_shake(var force_start : bool = false) -> void:
	if not force_start:
		if remaining_shake_duration > shake_duration and not infinite_duration:
			return
	
	#Init variables
	last_total_shake_duration = shake_duration
	last_shake_magnitude = shake_magnitude
	remaining_shake_duration = shake_duration
	is_current_infinite = infinite_duration
	current_delta_passed = 0
	current_frequency_round_time = 1 / shake_frequency

#Returns true if shaking process is already on-going.
func is_shaking() -> bool:
	return remaining_shake_duration > 0 or is_current_infinite

#Stops shaking immediately.
func stop_shaking() -> void:
	remaining_shake_duration = 0
	is_current_infinite = false
	_set_root_node_property(vector_property_to_set, Vector2())

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _do_process(delta : float) -> void:
	if remaining_shake_duration <= 0 and not is_current_infinite:
		return
	
	var _fetched_root_node := get_node(root_node)
	var can_change_position = false
	
	#Decrease remaining shake duration (shaking is in-progress)
	remaining_shake_duration -= delta
	current_delta_passed += delta
	
	if remaining_shake_duration < 0:
		remaining_shake_duration = 0
		
		if not is_current_infinite:
			emit_signal("shake_finished")
	
	#Calculate a complete cycle of frequency.
	current_delta_passed -= current_frequency_round_time 
	can_change_position = true
	
	if not can_change_position and remaining_shake_duration != 0: #Frequency round time not reached
		return
	if _fetched_root_node == null:
		return
	if not typeof(_fetched_root_node.get(vector_property_to_set)) == TYPE_VECTOR2:
		return
	else:
		var calculated_interpolate_magnitude : float
		
		if not is_current_infinite:
			if remaining_shake_duration == 0:
				calculated_interpolate_magnitude = 0
			elif can_change_position: #Frequency round time reached
				calculated_interpolate_magnitude = shake_curve.interpolate_baked(lerp(1, 0, remaining_shake_duration / last_total_shake_duration)) * last_shake_magnitude
		else:
			calculated_interpolate_magnitude = last_shake_magnitude
		
		var randomized_position = Vector2(
			rand_range(-calculated_interpolate_magnitude, calculated_interpolate_magnitude),
			rand_range(-calculated_interpolate_magnitude, calculated_interpolate_magnitude)
		) + shake_offset
		
		_fetched_root_node.set(vector_property_to_set, randomized_position)

func _set_root_node_property(vector_property_to_set : String, value : Vector2):
	var _fetched_root_node := get_node(root_node)
	
	if _fetched_root_node == null:
		return
	if not typeof(_fetched_root_node.get(vector_property_to_set)) == TYPE_VECTOR2:
		return
	
	_fetched_root_node.set(vector_property_to_set, value)

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_root_node(val : NodePath) -> void:
	root_node = val

func get_root_node() -> NodePath:
	return root_node

func set_shake_duration(val : float) -> void:
	shake_duration = val

func get_shake_duration() -> float:
	return shake_duration

func set_shake_magnitude(val : float) -> void:
	shake_magnitude = val

func get_shake_magnitude() -> float:
	return shake_magnitude

func set_curve(val : Curve) -> void:
	if val == null:
		val = Curve.new()
		val.add_point(Vector2(0, 1), 0, -2.5)
		val.add_point(Vector2(1, 0))
	
	shake_curve = val

func get_shake_curve() -> Curve:
	return shake_curve

func set_shake_offset(val : Vector2) -> void:
	shake_offset = val

func get_shake_offset() -> Vector2:
	return shake_offset

func set_shake_frequency(val : float) -> void:
	shake_frequency = val

func get_shake_frequency() -> float:
	return shake_frequency
