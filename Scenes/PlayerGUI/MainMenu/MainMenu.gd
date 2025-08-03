extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(SceneManager.ROOT)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
