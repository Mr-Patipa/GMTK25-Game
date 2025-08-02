extends Interactable
class_name SlotMachine

signal machine_activated

var Activated : bool = false

func activate(player : Player) -> void:
	if not Activated:
		Activated = true
		machine_activated.emit()
