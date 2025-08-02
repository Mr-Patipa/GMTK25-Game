extends Node

var slotAmount: int = 3
var currentSlot: int = 1
var secondsPerText: float = .5

var difficulty_additions = {"DARK": self.makeDarkAndFast,
							"FIVE": self.increaseSlotAmount}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addDifficulty() -> void:
	# Get difficulty to add
	var addOnKey = difficulty_additions.keys().pick_random()
	var addOn = difficulty_additions[addOnKey]
	difficulty_additions.remove(addOn)
	
	addOn.call()

func increaseSlotAmount():
	self.slotAmount = 5
	
func makeDarkAndFast():
	#TO-DO: We need to fix the lighting issue so we can actually make it dark
	self.secondsPerText = .22

func assignSlots() -> void:
	var slots: Array[SlotMachine] = []
	for c in self.get_children():
		if c is SlotMachine:
			slots.append(c)
	
	self.currentSlot = 1
	for i in range(1, slotAmount+1):
		var slot: SlotMachine = slots.pick_random()
		slots.erase(slot)
		slot.assignNumber(i)
		slot.SlotMachineActivated.connect(self.updateMemoryGame)
		await get_tree().create_timer(.5).timeout
	
	for s in slots:
		s.assignNumber(-1)

func updateMemoryGame(order_number: int):
	if order_number == self.currentSlot:
		self.currentSlot = self.currentSlot + 1
		self.checkWinCondition()
	else:
		self.resetWinCondition()
		
func checkWinCondition():
	if self.currentSlot < self.slotAmount+1: return
	$Item.visible = true
	
func resetWinCondition():
	# TO-DO: Play sad sound
	self.assignSlots()

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent() is not Player: return
	self.assignSlots()
