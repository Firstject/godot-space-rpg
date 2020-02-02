# LevelGUI
# Written by: First

extends CanvasLayer

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

const HP_CRITICAL_PERCENT = 0.4
const SHIELD_CRITICAL_PERCENT = 0.3

#-------------------------------------------------
#      Properties
#-------------------------------------------------

onready var playfield_input := $PlayfieldGUI

onready var level_bar = $MarginContainer/Control/PlayerHpBar/VBox/LvHpSuper/LevelBar
onready var level_label = $MarginContainer/Control/PlayerHpBar/VBox/LvHpSuper/LevelBar/Label
onready var level_up_anim = $MarginContainer/Control/PlayerHpBar/VBox/LvHpSuper/LevelBar/LevelUpAnim

onready var hp_text_curr_value = $MarginContainer/Control/PlayerHpBar/VBox/LvHpSuper/HpSuperVBox/HpText/Value
onready var hp_text_max_value = $MarginContainer/Control/PlayerHpBar/VBox/LvHpSuper/HpSuperVBox/HpText/MaxValue
onready var hp_bar = $MarginContainer/Control/PlayerHpBar/VBox/LvHpSuper/HpSuperVBox/HpBar
onready var hp_anim = $MarginContainer/Control/PlayerHpBar/VBox/LvHpSuper/HpSuperVBox/HpAnim

onready var super_bar = $MarginContainer/Control/PlayerHpBar/VBox/LvHpSuper/HpSuperVBox/SuperBar

onready var shield_hbox = $MarginContainer/Control/PlayerHpBar/VBox/Shield
onready var shield_percent_text = $MarginContainer/Control/PlayerHpBar/VBox/Shield/TextHbox/Value
onready var shield_anim = $MarginContainer/Control/PlayerHpBar/VBox/Shield/ShieldAnim

onready var showhide_ahim = $ShowHideAnim

onready var pause_btn = $MarginContainer/Control/PauseButton
onready var superpower_btn := $MarginContainer/Control/Utilities/SuperpowerButton as ExtendedButton
onready var superpower_btn_anim = $MarginContainer/Control/Utilities/SuperpowerButton/ButtonAnim

#---

onready var level_text_anim = $LevelText/LevelTextAnim
onready var level_text_hbox = $LevelText/TextHBox

#---

onready var level_end_anim = $LevelEnd/Anim

#---

onready var damage_anim = $Damage/DamageAnim

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

func _ready() -> void:
	$MarginContainer.set_visible(false)
	$LevelText.set_visible(false)
	$Damage.set_visible(false)
	BattleServer.connect("player_dead", self, "_on_BattleServer_player_dead")

#-------------------------------------------------
#      Virtual Methods
#-------------------------------------------------

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func set_gui_visible(set : bool) -> void:
	if set:
		showhide_ahim.play("Show")
	else:
		showhide_ahim.play("Hide")

func start_stage_enter_anim() -> void:
	level_text_anim.play("FlyinOut")

func update_player_status(player_obj : PlayerShip) -> void:
	#Set HP/MaxHP
	hp_text_max_value.set_text(str(player_obj.max_hp))
	if player_obj.hp < 0:
		hp_text_curr_value.set_text("0")
	else:
		hp_text_curr_value.set_text(str(player_obj.hp))
	hp_bar.set_max(player_obj.max_hp)
	hp_bar.set_value(player_obj.hp)
	_update_hp_anim(player_obj.get_hit_points_percentage())
	
	#Set shield status
	var player_has_shield = player_obj.has_shield()
	shield_hbox.set_visible(player_has_shield)
	if player_has_shield:
		var plyr_shield_pc = player_obj.get_shield().current_power_percent
		
		shield_percent_text.set_text(str(round(plyr_shield_pc * 100)))
		_update_shield_anim(plyr_shield_pc)
	
	#Set Lv and exp
	level_label.set_text(str(player_obj.lv))
	level_bar.set_min(player_obj.exp_system.get_required_exp(player_obj.exp_system.current_level - 1))
	level_bar.set_max(player_obj.exp_system.get_required_exp())
	level_bar.set_value(player_obj.exp_system.current_exp)
	
	#Set super status
	var player_has_superpower = player_obj.has_superpower()
	super_bar.set_visible(player_has_superpower)
	if player_has_superpower:
		super_bar.set_max(player_obj.get_superpower().get_max_power_point())
		super_bar.set_value(player_obj.get_superpower().current_power_pts)


func update_level_name(new_name : String) -> void:
	_qfree_level_text_hbox_children()
	_instance_labels_by_text(new_name)

func play_level_up_anim() -> void:
	level_up_anim.play("LevelUp")

func play_dmg_anim() -> void:
	damage_anim.play("Damage")

func set_superpower_btn_disabled(disabled : bool) -> void:
	if disabled: 
		superpower_btn_anim.play("Used")
	else:
		superpower_btn_anim.play("Ready")
	
	superpower_btn.set_disabled(disabled)

func start_level_clear_anim():
	level_end_anim.play("Clear")
	set_gui_visible(false)

func start_level_fail_anim():
	level_end_anim.play("Fail")
	set_gui_visible(false)

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_RestartButton_pressed() -> void:
	$LevelEnd.visible = false
	get_tree().paused = false
	set_superpower_btn_disabled(true)
	get_tree().reload_current_scene()

func _on_BattleServer_player_dead(player_obj) -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().paused = true
	start_level_fail_anim()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _qfree_level_text_hbox_children() -> void:
	for i in level_text_hbox.get_children():
		i.queue_free()

func _instance_labels_by_text(new_strings : String) -> void:
	for i in new_strings:
		var lb = Label.new()
		level_text_hbox.add_child(lb)
		lb.set_text(str(i))

func _update_shield_anim(curr_shield_percent):
	if curr_shield_percent < SHIELD_CRITICAL_PERCENT:
		shield_anim.play("Low")
	else:
		shield_anim.play("Normal")

func _update_hp_anim(curr_hp_percent):
	if curr_hp_percent < HP_CRITICAL_PERCENT:
		hp_anim.play("Low")
	else:
		hp_anim.play("Normal")

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------



