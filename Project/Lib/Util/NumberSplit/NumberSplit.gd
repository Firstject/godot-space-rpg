# NumberSplit
# Written by: First 

extends Node

class_name Util_NumberSplit

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

#-------------------------------------------------
#      Properties
#-------------------------------------------------

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

static func isplit(value : int, split_count : int, rand_factor : float = 0) -> PoolIntArray:
	var pool_int : PoolIntArray
	var splited_value = value / split_count
	var diff_rand : int = splited_value * rand_factor
	
	#Fill pool int with splited value
	for i in split_count:
		pool_int.append(splited_value)
	
	#Transfer from index to next index
	if split_count <= 1:
		return pool_int
	for i in range(split_count):
		var _transfer_rand = 0
		if diff_rand != 0: #Avoid division by zero.
			_transfer_rand = randi() % diff_rand
		
		pool_int[wrapi(i + 1, 0, split_count)] += _transfer_rand
		pool_int[i] -= _transfer_rand
	
	return pool_int

static func fsplit(value : float) -> Array:
	return []

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

