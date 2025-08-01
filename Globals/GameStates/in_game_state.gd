extends Node


@export var DeathDuration : float = 2
@export var DeathTimer : Timer
@export var BGMusic : AudioStreamPlayer 
@export var ScaryMusic : AudioStreamPlayer

@export_category("End Game Stats")
@export var TimeCounter : Timer

var Victory : bool = false


func _ready() -> void:
	playBGMusic()
	GameManager.time_ran_out.connect(endGamePreparation)
	GameManager.not_much_time_left.connect(playScaryMusic)
	DeathTimer.timeout.connect(func() -> void: GameManager.game_ended.emit())


func playBGMusic() -> void:
	BGMusic.play()

func playScaryMusic() -> void:
	BGMusic.stop()
	ScaryMusic.play()


func endGamePreparation() -> void:
	DeathTimer.set_wait_time(DeathDuration)
	DeathTimer.start()
	
