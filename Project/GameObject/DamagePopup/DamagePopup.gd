# DamagePopup
# Written by: First

extends Node2D

class_name DamagePopup

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

enum DamageType {
	PLAYER,
	PLAYER_CRITICAL,
	ENEMY,
	ENEMY_CRITICAL,
	HEAL,
	NO_DAMAGE
}

const CRITICAL_SUFFIX := "!"
const DAMAGE_COLORS = {
	0: Color("ff6000"), #Orange | Player
	1: Color("ff0000"), #Red    | PlayerCritical
	2: Color("ffffff"), #White  | Enemy
	3: Color("ffff00"), #Yellow | EnemyCritical
	4: Color("00d100"), #Green  | Heal
	5: Color("555555")  #Gray   | NoDamage
}
const TYPE_CRITICALS = {
	0: false,
	1: true,
	2: false,
	3: true,
	4: false,
	5: false
}

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export (int) var number setget set_number
export (DamageType) var dmg_type setget set_dmg_type

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	$TextNode/BulletBehavior.angle_in_degrees = rand_range(0, 360)

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func start() -> void:
	_update_text()
	$Anim.stop()
	$Anim.play("New Anim")
	
	$TextNode/BulletBehavior.current_acceleration = 0.0
	$TextNode.position = Vector2()

static func is_critical_type(type : int) -> bool:
	return TYPE_CRITICALS.get(type)

#-------------------------------------------------
#      Connections
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _update_text() -> void:
	$TextNode/Label.set_text(str(number))
	if is_critical_type(dmg_type): #If it is critical
		$TextNode/Label.text += CRITICAL_SUFFIX

func _update_text_color_by_type() -> void:
	$TextNode/Label.add_color_override("font_color", DAMAGE_COLORS.get(dmg_type))

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func set_number(val : int) -> void:
	number = val

func set_dmg_type(val : int) -> void:
	dmg_type = val
	_update_text_color_by_type()
