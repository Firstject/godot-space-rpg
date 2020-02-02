# Pickups (Core)
# Written by: First

extends Node2D

class_name Pickups

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

const MIN_INITIAL_DEGREE = -180
const MAX_INITIAL_DEGREE = 0
const CAN_COLLECT_TIME = 0.3
const COLLECT_TIME = 0.18

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (bool) var auto_set_bullet_angle = true

export (int) var main_currency_add

export (Resource) var item_add

onready var bullet_bhv = $BulletBehavior
onready var collect_delay_timer = $CollectDelayTimer
onready var collect_anim = $CollectAnim

var collecting : bool = false
var collected : bool = false
var last_collected_gpos : Vector2
var current_source_obj : Node2D

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	init_bullet_speed()
	_start_can_collect_timer()
	_battleserver_change_total_pickups_count(1)

func _process(delta: float) -> void:
	_test_fly_toward_source_obj()

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func collect(source_obj : Node2D):
	if collecting or collected:
		return
	
	last_collected_gpos = global_position
	current_source_obj = source_obj
	collect_delay_timer.start(COLLECT_TIME)
	bullet_bhv.active = false
	Currency.add_main_currency(main_currency_add)
	
	collecting = true

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_CanCollectTimer_timeout() -> void:
	$Hitbox/Area2D.set_monitorable(true)

func _on_CollectDelayTimer_timeout() -> void:
	collecting = false
	collected = true
	collect_anim.play("Collected")
	
	AudioCenter.sfx_combat_credits.play()

func _on_PickupsCore_tree_exiting() -> void:
	_battleserver_change_total_pickups_count(-1)

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func init_bullet_speed() -> void:
	if not auto_set_bullet_angle:
		return
	
	bullet_bhv.angle_in_degrees = rand_range(MIN_INITIAL_DEGREE, MAX_INITIAL_DEGREE)

func _start_can_collect_timer():
	$CanCollectTimer.start(CAN_COLLECT_TIME)

func _test_fly_toward_source_obj():
	if not is_instance_valid(current_source_obj):
		return
	
	if collecting:
		global_position = last_collected_gpos.linear_interpolate(
			current_source_obj.global_position,
			abs(1 - (collect_delay_timer.time_left / collect_delay_timer.wait_time))
		)

func _battleserver_change_total_pickups_count(amount : int):
	BattleServer.total_pickups_count += amount

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

