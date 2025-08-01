extends Area3D
class_name Item

@export var itemName: String
@export var amount = 1

# Signal that passes name of item and amount of item collected
signal collectedSignal(n: String, a: int) 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(self.itemName != "", "All items need a name.")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	# When the item's CollisionShape3D is entered.

	# Make sure player is colliding with it
	if (body is not Player and 
		body is not PlayerTest): return
	
	collectedSignal.emit(self.itemName, self.amount)

func _on_collected_signal(n, a) -> void:
	# When the player collects the item, delete self
	self.queue_free()


func _on_area_entered(area: Area3D) -> void:
	print(area)
