extends Node3D

# Difficulty additions
var difficulty_additions = {"PATHS": CardTablePathsComponent}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.difficulty_changed.connect(addDifficulty)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func addDifficulty() -> void:
	# Get difficulty to add
	var component_key = difficulty_additions.keys().pick_random()
	var component = difficulty_additions[component_key]
	difficulty_additions.erase(component_key)
	
	if component_key == "PATHS":
		addComponentPaths(component)
		return
	if component_key == "SHUFFLE":
		addComponentShuffle(component)
		return


func addComponentShuffle(component):
	pass
	
func addComponentPaths(component):
	# Add component to children cardTables and reparent
	for c in self.get_children():
		if c is cardTable:
			var n = component.new()
			c.add_child(n)
			c.pathSetup()
