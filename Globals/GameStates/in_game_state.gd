extends Node


@export var DeathDuration : float = 2
@export var DeathTimer : Timer
@export var MusicController : AudioStreamPlayer
@export var player : Player
@export var SpawnPos : Marker3D
@export var Detector : Area3D

@export_category("End Game Stats")
@export var TimeCounter : Timer

var Victory : bool = false
var IsEnding : bool = false

func _ready() -> void:
	player.global_position = SpawnPos.global_position
	MusicController.play()
	GameManager.time_ran_out.connect(endGamePreparation)
	GameManager.time_change_notified.connect(playScaryMusic)
	GameManager.player_saved.connect(playBGMusic)
	DeathTimer.timeout.connect(func() -> void: GameManager.game_ended.emit())
	Detector.body_entered.connect(func(_body : Node3D)-> void:player.global_position = SpawnPos.position)


func playBGMusic() -> void:
	pass
	if IsEnding:
		MusicController.set("parameters/switch_to_clip", "Background")
		IsEnding = false

func playScaryMusic(time : int) -> void:
	if time > 10 and IsEnding:
		IsEnding = false
		MusicController.set("parameters/switch_to_clip", "Background")
	
	if time == 10:
		IsEnding = true
		MusicController.set("parameters/switch_to_clip", "Scary")
		MusicController.play()
	
	elif time < 10 and not IsEnding:
		IsEnding = true
		MusicController.set("parameters/switch_to_clip", "Scary")


func endGamePreparation() -> void:
	DeathTimer.set_wait_time(DeathDuration)
	DeathTimer.start()
	
