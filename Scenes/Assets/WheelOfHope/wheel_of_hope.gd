extends Interactable
class_name TheWheel


@export var SpinTimes : int = 7 # Amount of time it spins before it slows down
@export var SpinDuration : float = 7 # Duration of each spins
@export var SliceCount : int = 8 # How many options are on the wheel
@export var CooldownTime : float = 2 # How long until you could spin the wheel again after it's finished
@export var TimeAdded : int = 60 # Amount of time added for every spin
@export var WheelBase : Marker3D
@export var CoolTimer : Timer
@export var BufferZone : Area3D

var SpinTween : Tween
var OnCooldown : bool
var ChosenSlice : int
var ExtraTime : int
var Activated : bool = false

func _ready() -> void:
	CoolTimer.timeout.connect(changeCoolDown)
	BufferZone.body_exited.connect(checkPlayer)


func activate(_player : Player) -> void:
	if not OnCooldown:
		OnCooldown = true
		startSpinning()
		GameManager.wheel_was_spun.emit()


func startSpinning() -> void:
	if SpinTween:
		SpinTween.kill()
	
	SpinTween = get_tree().create_tween()
	SpinTween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	SpinTween.tween_property(WheelBase, "rotation_degrees", Vector3(0, chooseLandPos(), 0), SpinDuration)
	SpinTween.play()
	SpinTween.finished.connect(checkStatus)


func chooseLandPos() -> float:
	randomize()
	var InitialOffset : float = 360 / SliceCount + (SliceCount / 2)
	ChosenSlice = randi_range(1, SliceCount)
	var LandPos : float = (SpinTimes * 360) + (InitialOffset * ChosenSlice)
	
	return LandPos


func checkStatus() -> void:
	ExtraTime = 0
	Activated = false
	
	CoolTimer.set_wait_time(CooldownTime)
	CoolTimer.start()
	
	print(ChosenSlice)
	match ChosenSlice:
		1:
			print("You Win")
	
	GameManager.time_updated.emit(TimeAdded + ExtraTime)


func changeCoolDown() -> void:
	OnCooldown = false
	WheelBase.rotation_degrees.y = 0
	

func TimeRandomizer() -> float:
	randomize()
	var Value : float = randf_range(SpinDuration - 0.4, SpinDuration + 0.2)
	return Value


func checkPlayer(body : Node3D) -> void:
	if body is Player and not Activated:
		Activated = true
		GameManager.player_readyed.emit()
