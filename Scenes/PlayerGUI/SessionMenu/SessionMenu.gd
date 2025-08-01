extends CanvasLayer

@export var World : Node3D
@export var OptionsMenu : Control

@export_category("Game Status UI")
var InitialGameTime : int = 60
var CurrentGameTimeLeft : int
@export var TimerLabel : Label
@export var GameTimer : Timer

func _ready() -> void:
	CurrentGameTimeLeft = InitialGameTime
	GameTimer.timeout.connect(changeTimeStatus)
	GameManager.wheel_was_spun.connect(func() -> void: GameTimer.stop())
	GameManager.player_readyed.connect(setUpTimer)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") == true:
		OptionsMenu.visible = true
		World["process_mode"] = Node.PROCESS_MODE_DISABLED


#region Game Options Menu Related
func _on_return_button_pressed() -> void:
	OptionsMenu.visible = false
	World["process_mode"] = Node.PROCESS_MODE_INHERIT

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(SceneManager.MAIN_MENU)

#endregion


#region Game Status Related
func setUpTimer(TimeAdded : int) -> void:
	CurrentGameTimeLeft += TimeAdded
	GameTimer.set_wait_time(1)
	GameTimer.start()



func changeTimeStatus() -> void:
	if CurrentGameTimeLeft > 0:
		CurrentGameTimeLeft -= 1
		TimerLabel.text = "Time Left: " + str(CurrentGameTimeLeft)
	
	else:
		GameTimer.stop()
		TimerLabel.text = "Game Over"
		GameManager.time_ran_out.emit()
	

#endregion
