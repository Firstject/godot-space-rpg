extends Node



func _on_SafeLoadSceneTimer_timeout() -> void:
	get_tree().change_scene("res://Scenes/Levels/just-some-crazy-level.tscn")
