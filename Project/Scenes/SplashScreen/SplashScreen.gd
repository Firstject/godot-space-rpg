extends Node

func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()

func _ready() -> void:
	get_tree().paused = false
	AudioCenter.stop_bgm()
	LevelGUI.set_fps_visible(false)

func _on_PlayBtn_pressed() -> void:
	get_tree().change_scene("res://Scenes/Levels/just-some-crazy-level.tscn")


func _on_PlayBtn2_pressed() -> void:
	get_tree().change_scene("res://Scenes/Levels/CalmStage.tscn")


func _on_AboutButton_pressed() -> void:
	$Popup/Popup.popup()
