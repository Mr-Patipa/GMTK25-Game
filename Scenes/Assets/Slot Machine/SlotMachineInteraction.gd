extends Interactable

signal SlotMachineInteraction

func activate(_player : Player) -> void:
	SlotMachineInteraction.emit()
