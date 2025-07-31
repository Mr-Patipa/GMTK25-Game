extends CanvasLayer

@export var World : Node3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") == true:
		visible = !visible
		World["process_mode"] = Node.PROCESS_MODE_DISABLED

func _on_return_button_pressed() -> void:
	visible = false
	World["process_mode"] = Node.PROCESS_MODE_INHERIT

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(SceneManager.MAIN_MENU)
