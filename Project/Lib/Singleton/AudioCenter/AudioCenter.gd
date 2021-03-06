# AudioManager
# Written by: First

extends Node

"""
	AudioCenter is a singleton audio player that plays
	background music and sound effects. The main advantage
	is to provide an easier way to play audio from anywhere
	without having to attach a sound effect to a node. Ex: An
	enemy carrying sound effect that plays when dies. That
	would become frustrated to handle by keeping enemy stay
	alive until the sound finishes playing to prevent sound
	effect getting killed.
	A background music can also be played here. No more than
	2 background musics are played at the same time.
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

#BGM (Background Music)
onready var bgm_core : AudioStreamPlayer = $BGM/BgmCore_DONT_TOUCH_THIS
onready var bgm_property_setter_player : AnimationPlayer = $BGM/BgmCore_DONT_TOUCH_THIS/PropertySetterPlayer

#Sfx (Sound Effects)
onready var sfx_ui_button1 : AudioStreamPlayer = $SFX/UI/Button1

onready var sfx_combat_beam_level_up : AudioStreamPlayer = $SFX/Combat/BeamLevelUp
onready var sfx_combat_credits : AudioStreamPlayer = $SFX/Combat/Credits
onready var sfx_combat_debris_kill : AudioStreamPlayer = $SFX/Combat/DebrisKill
onready var sfx_combat_enemy_dead1 : AudioStreamPlayer = $SFX/Combat/EnemyDead1
onready var sfx_combat_enemy_dead2 : AudioStreamPlayer = $SFX/Combat/EnemyDead2
onready var sfx_combat_enemy_hit : AudioStreamPlayer = $SFX/Combat/EnemyHit
onready var sfx_combat_enemy_shot1 : AudioStreamPlayer = $SFX/Combat/EnemyShot1
onready var sfx_combat_enemy_shot2 : AudioStreamPlayer = $SFX/Combat/EnemyShot2
onready var sfx_combat_level_up : AudioStreamPlayer = $SFX/Combat/LevelUp
onready var sfx_combat_player_damage : AudioStreamPlayer = $SFX/Combat/PlayerDamage
onready var sfx_combat_player_kill : AudioStreamPlayer = $SFX/Combat/PlayerKill
onready var sfx_combat_pulse_beam : AudioStreamPlayer = $SFX/Combat/PulseBeam
onready var sfx_combat_ring_spread : AudioStreamPlayer = $SFX/Combat/RingSpread
onready var sfx_combat_shield_block : AudioStreamPlayer = $SFX/Combat/ShieldBlock
onready var sfx_combat_super_ready : AudioStreamPlayer = $SFX/Combat/SuperReady

#TEMP
var current_bgm : String #Path


#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

#-------------------------------------------------
#      Notifications
#-------------------------------------------------

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#Play background music. Replaces current ongoing music.
#If the same music is being played, nothing will happen.
func play_bgm(var what_bgm : AudioStreamOGGVorbis) -> void:
	if what_bgm == null:
		return
	
	var new_bgm_path : String = what_bgm.get_path()
	
	if new_bgm_path != current_bgm:
		bgm_core.volume_db = 0
		bgm_core.set_stream(what_bgm)
		bgm_core.play()
		current_bgm = new_bgm_path

#Stop background music immediately, completely mutes it.
func stop_bgm() -> void:
	bgm_core.stop()
	current_bgm = ""

#Lower volume of current background music down a bit.
func dim_bgm() -> void:
	bgm_property_setter_player.play("Dim")

#Increase volume of current background music up to normal.
func undim_bgm() -> void:
	bgm_property_setter_player.play("Undim")

#Fade out current music's volume.
#An optional parameter of bool can be passed to stop bgm completely.
func fade_out_bgm(var stop_bgm_after_faded : bool = false) -> void:
	if stop_bgm_after_faded:
		bgm_property_setter_player.play("FadeOutStop")
	else:
		bgm_property_setter_player.play("FadeOutNoStop")



#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------
