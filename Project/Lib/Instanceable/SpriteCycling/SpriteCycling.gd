# Sprite Cycling
# Written by: First

extends Node

class_name SpriteCycling

"""
	Sprite Cycling turns all children within the root node
	to draw sprites in forward order one frame and
	backward order the next when two sprites are overlapping
	each other.
	
	**Usage:**
	
	Instance this node (or through adding a node) and specify
	the target node you want all of its children to have
	this behavior applied.
"""


#-------------------------------------------------
#      Properties
#-------------------------------------------------

#The node you want all of its children to have this behavior applied.
export (NodePath) var root_node = "./.."

#When false, this will have no effect and won't do anything.
export(bool) var active = true setget set_active, is_active

#Array length should be power of n. e.g. 1, 2, 4, or 8, ..
#this will wait for n frames before iterate starts.
#There is a pointer that will move to the next of an array
#once iteration is done in said frame.
export(Array, int) var frames_per_iterate = [0]


#Increment every frames. Resets on reaching frames_per_iterate[pointer]
var z_swapping = 0 

#Pointer on array of frames_per_iterate
var pointer = 0

#0 = no iterate, other than 0 = iterate
var swap_mode = 0 





#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _process(delta : float) -> void:
	if Engine.is_editor_hint():
		return
	if not active:
		return
	
	var _fetched_root_node = get_node(root_node)
	if _fetched_root_node == null: return
	var children = _fetched_root_node.get_children()
	var it = children.size()
	
	for i in children:
		if(swap_mode == 0):
			it += 1
		else:
			it -= 1
		if "z_index" in i: #Safe call
			i.z_index = it
	
	if(z_swapping >= frames_per_iterate[pointer]):
		z_swapping = 0
		_modify_swap_mode()
		pointer = _move_pointer(pointer, frames_per_iterate)
	else:
		z_swapping += 1



#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _modify_swap_mode():
	swap_mode = int(!bool(swap_mode))

func _move_pointer(var which_pointer : int, var which_array : Array):
	if which_pointer >= which_array.size() - 1:
		which_pointer = 0
	else:
		which_pointer += 1
	
	return which_pointer


#-------------------------------------------------
#       Setters & Getters
#-------------------------------------------------

func set_active(val : bool) -> void:
	active = val

func is_active() -> bool:
	return active
