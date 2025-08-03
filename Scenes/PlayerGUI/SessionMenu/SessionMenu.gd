extends CanvasLayer

@export var World : Node3D
@export var OptionsMenu : Control
@export var VolumeController : Control

@export_category("Game Status UI")
@export var InitialGameTime : int = 20
@export var TimerLabel : Label
@export var GameTimer : Timer
var CurrentGameTimeLeft : int

@export_category("Game Over UI")
@export var FadeDuration : float = 0.5 # How long it takes to fade to black
@export var GameOver : Control
@export var GameStatus : Label
@export var Background : TextureRect
@export var BestTimeLabel : Label
@export var MostTimeLabel : Label
@export var CurrentTimeLabel : Label
@export var PlayBtn : Button
@export var MenuBtn : Button
var IsEnding = false

@export_category("Dialogue Menu related")
@export var DialogueMenu : Control
@export var NameCard : Label
@export var Text : Label
var InDialogue : bool = false

@export var debugMode := false

@export_category("End Game Stats")
@export var TimeCounter : Timer
var IsCounting : bool = false


func _ready() -> void:
	CurrentGameTimeLeft = InitialGameTime
	GameTimer.timeout.connect(changeTimeStatus)
	GameManager.dialogue_opened.connect(func(): DialogueMenu.visible = true)
	GameManager.wheel_dialogue_needed.connect(checkAvailable)
	GameManager.wheel_was_spun.connect(func() -> void: GameTimer.stop())
	GameManager.time_updated.connect(setUpTimer)
	GameManager.player_saved.connect(playerSaved)
	GameManager.player_readyed.connect(playerReadyed)
	GameManager.game_ended.connect(startEnding)
	GameManager.dialogue_triggered.connect(triggerVisibility)
	GameManager.dialogue_sent.connect(dialogueTextChange)
	GameManager.dialogue_name_sent.connect(dialogueNameChange)
	GameManager.player_has_died.connect(startEnding)
	
	MenuBtn.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(SceneManager.MAIN_MENU)
	)
	
	PlayBtn.pressed.connect(func() -> void:
		get_tree().change_scene_to_file(SceneManager.ROOT)
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") == true:
		OptionsMenu.visible = true
		VolumeController.visible = true
		World["process_mode"] = Node.PROCESS_MODE_DISABLED


#region Game Options Menu Related
func _on_return_button_pressed() -> void:
	OptionsMenu.visible = false
	VolumeController.visible = false
	World["process_mode"] = Node.PROCESS_MODE_INHERIT

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(SceneManager.MAIN_MENU)

#endregion


#region Game Status Related
func setUpTimer(TimeAdded : int) -> void:
	CurrentGameTimeLeft += TimeAdded
	TimerLabel.text = "Time Left: " + str(CurrentGameTimeLeft)


func playerReadyed() -> void:
	if debugMode: return
	
	GameManager.time_change_notified.emit(CurrentGameTimeLeft)
	
	GameTimer.set_wait_time(1)
	GameTimer.start()
	
	if IsCounting == false:
		IsCounting = true
		TimeCounter.set_wait_time(1)
		TimeCounter.start()
		TimeCounter.timeout.connect(func() -> void: GameManager.CurrentTime += 1)


func playerSaved() -> void:
	GameTimer.stop()

func changeTimeStatus() -> void:
	if CurrentGameTimeLeft > 0:
		CurrentGameTimeLeft -= 1
		TimerLabel.text = "Time Left: " + str(CurrentGameTimeLeft)
		GameManager.time_change_notified.emit(CurrentGameTimeLeft)
	
	else:
		GameTimer.stop()
		TimerLabel.text = "Game Over"
		GameManager.time_ran_out.emit()
	
	if CurrentGameTimeLeft < 11 and not IsEnding:
		if not debugMode:
			IsEnding = true
			GameManager.not_much_time_left.emit()
		
	
	elif CurrentGameTimeLeft >= 11:
		IsEnding = false

#endregion


#region Game Over Related
var FadeTween : Tween


func startEnding() -> void:
	if FadeTween:
		FadeTween.kill()
	
	GameOver.visible = true
	GameOver.get_node("Others").visible = false
	Background.modulate = Color8(00,00,00,00)
	FadeTween = get_tree().create_tween()
	FadeTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	FadeTween.tween_property(Background, "modulate", Color8(00,00,00), FadeDuration)
	FadeTween.finished.connect(func() -> void:
		GameOver.get_node("Others").visible = true
		if GameManager.GameWon == true:
			GameStatus.text = "You Win!"
	)
	TimeCounter.stop()
	if GameManager.BestTime == 0:
		GameManager.BestTime = GameManager.CurrentTime
	elif GameManager.CurrentTime < GameManager.BestTime:
		GameManager.BestTime = GameManager.CurrentTime
	if GameManager.MostTime == 0:
		GameManager.MostTime = GameManager.CurrentTime
	elif GameManager.CurrentTime > GameManager.MostTime:
		GameManager.MostTime = GameManager.CurrentTime
	
	
	BestTimeLabel.text = str(GameManager.BestTime) + " s"
	MostTimeLabel.text = str(GameManager.MostTime) + " s"
	CurrentTimeLabel.text = str(GameManager.CurrentTime) + " s"


#endregion


#region Villain Dialogue Box Related
func triggerVisibility() -> void:
	if DialogueMenu.visible == false:
		DialogueMenu.visible = true
		InDialogue = true
	
	else:
		DialogueMenu.visible = false
		InDialogue = false


func dialogueTextChange(text : String) -> void:
	Text.text = text

func dialogueNameChange(text :  String) -> void:
	NameCard.text = text

#endregion


#region Wheel Dialogue Related
func checkAvailable(timer : Timer, name_card : String, text : String) -> void:
	if InDialogue == true:
		timer.stop()
	
	NameCard.text = name_card
	Text.text = text


#endregion
