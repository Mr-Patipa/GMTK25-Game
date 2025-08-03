extends Interactable
class_name William

var CurrentItemCount : int = 0
@export var ItemNeeded : int = 3
@export var EndTime : float = 3
@export var ArialPrompt : ArialUI
@export var EndTimer : Timer

var DialogueActive : bool = false
var CurrentOrder : int = 0
var CurrentText : String
var CurrentDialogue : Array[String]
var plr : Player


var Initial : bool = false
var InitialDialogue : Array[String] = [
	"Yo yo yo, big bad boy in town here. I ain't gonna let you out if ya don't hand me some goodies...",
	"Go fetch me thing1, thing2, thing3, thing4 and thing5.",
	"I give you a minute...",
	"Or if you spin my roulette here *winks*
	I'll allow some extra time, but it comes with some price to pay.",
	"Hurry up! Don't keep the devil waiting for yah."
]

var WithNoItemsV1 : Array[String] = [
	"Quit bugging me till ya find me more goodies...",
	"A deal's a deal."
]

var WithNoItemsV2 : Array[String] = [
	"One day a man signed a contract and it's got your name on it...",
	"A deal's a deal."
]

var ItemGottenV1 : Array[String] = [
	"Nicely done!, now fetch me more...",
	"A deal's a deal."
]

var ItemGottenV2 : Array[String] = [
	"He he he, what about the other one?",
	"A deal's a deal."
]

var ItemGottenAll : Array[String] = [
	"Splended, I knew I could trust you after all...",
	"See you soon pal."
]

func _ready() -> void:
	EndTimer.timeout.connect(func() -> void:
		GameManager.game_ended.emit()
	)


func activate(player : Player) -> void:
	plr = player
	
	if not Initial:
		CurrentDialogue = InitialDialogue
	else:
		
		
		if plr.ItemCount == 0:
			CurrentDialogue = [WithNoItemsV1, WithNoItemsV2].pick_random()
		
		else:
			CurrentItemCount += plr.ItemCount
			plr.ItemCount = 0
			CurrentDialogue = [ItemGottenV1, ItemGottenV1].pick_random()
		
		if CurrentItemCount == ItemNeeded:
			CurrentDialogue = ItemGottenAll
		
	
	GameManager.dialogue_triggered.emit()
	GameManager.dialogue_sent.emit("...")
	GameManager.dialogue_name_sent.emit("William")
	
	
	if player.Machine.Active == false:
		player.Machine.Active = true
		DialogueActive = false
		ArialPrompt.visible = true
	
	else:
		player.Machine.Active = false
		DialogueActive = true
		ArialPrompt.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("DialogueMove") and DialogueActive == true:
		if CurrentOrder < CurrentDialogue.size():
			CurrentText = CurrentDialogue[CurrentOrder]
			GameManager.dialogue_sent.emit(CurrentText)
			CurrentOrder += 1
		
		else:
			CurrentOrder = 0
			GameManager.dialogue_triggered.emit()
			plr.Machine.Active = true
			DialogueActive = false
			ArialPrompt.visible = true
			
			if not Initial:
				Initial = true
			
			else:
				if CurrentItemCount == ItemNeeded:
					EndTimer.set_wait_time(EndTime)
					EndTimer.start()
					GameManager.GameWon == true
