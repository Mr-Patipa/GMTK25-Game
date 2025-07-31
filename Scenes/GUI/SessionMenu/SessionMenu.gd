extends CanvasLayer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") == true:
		visible = !visible


func _on_general_button_pressed() -> void:
	visible = false


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(SceneManager.MAIN_MENU)
