extends StaticBody3D
class_name SlotMachine

@export var AnimPlayer : AnimationPlayer
var order_number: int = -1

signal SlotMachineActivated(order_number)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activate() -> void:
	SlotMachineActivated.emit(order_number)
	AnimPlayer.play("Spinning")
	AnimPlayer.animation_finished.connect(func(animation) -> void:
		AnimPlayer.play("Idle")
	)

func assignNumber(num: int):
	self.order_number = num
	if num > 0:
		$"Order Number".text = str(self.order_number)
		$"Order Number".visible = true
		$"Text Timer".start()
		

func _on_text_timer_timeout() -> void:
	$"Order Number".visible = false


func _on_interactable_slot_machine_interaction() -> void:
	self.activate()
