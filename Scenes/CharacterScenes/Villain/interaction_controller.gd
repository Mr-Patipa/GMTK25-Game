extends Interactable

@export var ArialPrompt : ArialUI

var InDialogue : bool = false

func activate(player : Player) -> void:
	GameManager.dialogue_triggered.emit()
	ArialPrompt.Disabled = true
	player.Machine.Active = false
	InDialogue = true

func _unhandled_input(_event: InputEvent) -> void:
	if InDialogue and _event.is_action_pressed("Interact"):
		GameManager.dialogue_sent.emit("Ya ya we redy fo enyting")
		
