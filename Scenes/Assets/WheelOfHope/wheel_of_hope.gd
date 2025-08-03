extends Interactable
class_name TheWheel


@export var SpinTimes : int = 16 # Amount of time it spins before it slows down
@export var SpinDuration : float = 9 # Duration of each spins
@export var SliceCount : int = 7 # How many options are on the wheel
@export var CooldownTime : float = 2 # How long until you could spin the wheel again after it's finished
@export var TimeAdded : int = 60 # Amount of time added for every spin
@export var WheelBase : Marker3D
@export var CoolTimer : Timer
@export var BufferZone : Area3D
@export var SpinSFX : AudioStreamPlayer3D


@export_category("Enemies Related")
@export var EnemySpawnPoints : Node3D
@export var Chaser : PackedScene
@export var SpawnAmount : int = 2 ## How many enemies needed to be spawned in

@export_category("Player Related")
@export var ExtraSpeed : float = 3
@export var ReducedSpeed : float = 3
@export var EffectsTime : float = 30
@export var ExtraTime : int = 30
@export var PlaceholderTimer : Timer
var Affected : bool = false

@export_category("Dialogue Related")
@export var DialogueTimer : Timer
@export var DialogueTime : float = 3

@export_category("Lights related")
@export var Lights : Node3D
@export var AmbientLight : DirectionalLight3D
@export var LightsOutTime : float = 60


var SpinTween : Tween
var OnCooldown : bool
var ChosenSlice : int
var plr : Player
var IsReady : bool


func _ready() -> void:
	CoolTimer.timeout.connect(changeCoolDown)
	BufferZone.body_entered.connect(func(_body : Node3D) -> void:
		plr = _body
		GameManager.player_saved.emit()
	)
	
	BufferZone.body_exited.connect(func(_body : Node3D) -> void:
		plr = _body
		GameManager.player_readyed.emit()
	)
	DialogueTimer.timeout.connect(func() -> void:
		GameManager.dialogue_triggered.emit()
	)
	GameManager.dialogue_triggered.connect(func() -> void: DialogueTimer.stop())


func activate(player : Player) -> void:
	plr = player
	if not OnCooldown:
		OnCooldown = true
		startSpinning()
		GameManager.wheel_was_spun.emit()


func startSpinning() -> void:
	if SpinTween:
		SpinTween.kill()
	SpinSFX.play()
	
	SpinTween = get_tree().create_tween()
	SpinTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	SpinTween.tween_property(WheelBase, "rotation_degrees", Vector3(0, chooseLandPos(), 0), SpinDuration)
	SpinTween.play()
	SpinTween.finished.connect(checkStatus)


func chooseLandPos() -> float:
	randomize()
	@warning_ignore("integer_division")
	var InitialOffset : float = 360 / SliceCount + (SliceCount / 2)
	ChosenSlice = randi_range(1, SliceCount)
	var LandPos : float = (SpinTimes * 360) + (InitialOffset * ChosenSlice)
	
	return LandPos


func checkStatus() -> void:
	CoolTimer.set_wait_time(CooldownTime)
	CoolTimer.start()
	
	var NewEnemy : ChaserEnemy 
	var NewSpawn : Marker3D
	var NewTimer : Timer
	var Machine : StateMachine 
	var PlusTime : int = 0
	var text : String
	
	print(ChosenSlice)
	
	match ChosenSlice:
		1:
			#You won the game...
			GameManager.game_ended.emit()
			text = "You win"
			GameManager.GameWon == true
		
		2:
			#Spawn Angry Enemy
			for i in range(0, SpawnAmount, 1):
				NewEnemy = Chaser.instantiate()
				NewSpawn = EnemySpawnPoints.get_children().pick_random()
				Machine = NewEnemy.get_node("StateMachine")
				NewEnemy.PlayerRef = plr
				Machine.Active = true
				Machine.InitialState = Machine.get_node("Chasing")
				get_parent().add_child(NewEnemy)
				NewEnemy.global_position = NewSpawn.global_position
			
			text = "+ " + str(TimeAdded) + " seconds" + "
				Two Extra Ghost Spawned in!"
		
		3:
			#Change game difficulty
			GameManager.difficulty_changed.emit()
			text = "+ " + str(TimeAdded) + " seconds" + "
				Games are now harder!"
		
		4:
			#Give player exetra speed
			plr.SpeedChange += ExtraSpeed
			PlusTime -= ExtraTime
			NewTimer = PlaceholderTimer.duplicate()
			plr.Modifiers.add_child(NewTimer)
			NewTimer.set_wait_time(EffectsTime)
			NewTimer.timeout.connect(func() -> void:
				plr.SpeedChange -= ExtraSpeed
				NewTimer.call_deferred("queue_free")
			)
			text = "+ " + str(TimeAdded + PlusTime) + " seconds" + "
				Your movement speed has been increased!"
		
		5:
			#Reduce player speed
			PlusTime = ExtraTime /2
			plr.SpeedChange -= ReducedSpeed
			NewTimer = PlaceholderTimer.duplicate()
			plr.Modifiers.add_child(NewTimer)
			NewTimer.set_wait_time(EffectsTime)
			NewTimer.timeout.connect(func() -> void:
				plr.SpeedChange += ReducedSpeed
				NewTimer.call_deferred("queue_free")
			)
			text = "+ " + str(TimeAdded + PlusTime) + " seconds" + "
				Your movement Speed has decreased"
		
		6:
			#Reverse control
			plr.Inversed = true
			PlusTime = ExtraTime
			NewTimer = PlaceholderTimer.duplicate()
			plr.Modifiers.add_child(NewTimer)
			NewTimer.set_wait_time(EffectsTime)
			NewTimer.timeout.connect(func() -> void:
				plr.Inversed = false
				NewTimer.call_deferred("queue_free")
			)
			text = "+ " + str(TimeAdded + PlusTime) + " seconds" + "
				Your controls are now reversed"
			
		7:
			# Lights out and flickering
			AmbientLight.visible = false
			NewTimer = PlaceholderTimer.duplicate()
			plr.Modifiers.add_child(NewTimer)
			NewTimer.set_wait_time(LightsOutTime)
			NewTimer.timeout.connect(func() -> void:
				AmbientLight.visible = true
			)
			text = "+ " + str(TimeAdded) + " seconds" + "
				Lights are out for " + str(LightsOutTime)
	
	
	DialogueTimer.set_wait_time(DialogueTime)
	DialogueTimer.start()
	GameManager.dialogue_opened.emit()
	GameManager.wheel_dialogue_needed.emit(DialogueTimer, "Machine", text)
	GameManager.time_updated.emit(TimeAdded + PlusTime)


func changeCoolDown() -> void:
	OnCooldown = false
	WheelBase.rotation_degrees.y = 0


func TimeRandomizer() -> float:
	randomize()
	var Value : float = randf_range(SpinDuration - 0.4, SpinDuration + 0.2)
	return Value
