extends Node



func _on_DTimer_timeout() -> void:
	get_tree().change_scene("res://Scenes/Levels/just-some-crazy-level.tscn")
