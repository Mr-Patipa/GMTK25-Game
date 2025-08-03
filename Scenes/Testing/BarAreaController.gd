extends Node

@export var Bartender: PackedScene

var rightSpawns: Path3D
var leftSpawns: Path3D

func _ready() -> void:
	rightSpawns = $"Right Spawns"
	leftSpawns = $"Left Spawns"
	GameManager.difficulty_changed.connect(addDifficulty)
	

func _process(delta: float) -> void:
	# Check if there's no more bartenders, then spawn
	for c in self.get_children():
		if c is Bartender:
			return
	spawn_bartenders()

func spawn_bartenders():
	var right_pos = []
	var left_pos = []
	var bartenders = []
	
	right_pos.append(randf_range(0,.1))
	right_pos.append(randf_range(.1,.2))
	right_pos.append(randf_range(.2,.3))
	right_pos.append(randf_range(.4,.5))
	right_pos.append(randf_range(.6,.7))
	right_pos.append(randf_range(.7,.8))
	right_pos.append(randf_range(.8,.9))
	right_pos.append(randf_range(.9,1.0))
	
	left_pos.append(randf_range(0,.1))
	left_pos.append(randf_range(.1,.2))
	left_pos.append(randf_range(.2,.3))
	left_pos.append(randf_range(.4,.5))
	left_pos.append(randf_range(.6,.7))
	left_pos.append(randf_range(.7,.8))
	left_pos.append(randf_range(.8,.9))
	left_pos.append(randf_range(.9,1.0))
	
	for p in right_pos:
		var new_point = rightSpawns.curve.sample_baked(p*rightSpawns.curve.get_baked_length())
		new_point = rightSpawns.to_global(new_point)
		#print(new_point)
		new_point = Vector3(rightSpawns.global_position.x, rightSpawns.global_position.y+1.1, new_point.z)
		var new_bartender = Bartender.instantiate()
		self.add_child(new_bartender)
		new_bartender.global_position = new_point
		
		new_bartender.target = (Vector3($"Left Gutter".global_position.x+50,
									new_bartender.global_position.y,
									new_bartender.global_position.z + randi_range(-30,30)))
		bartenders.append(new_bartender)
		$"Left Gutter".body_entered.connect(new_bartender.checkBarrier)

		
	for p in left_pos:
		var new_point = leftSpawns.curve.sample_baked(p*leftSpawns.curve.get_baked_length())
		new_point = leftSpawns.to_global(new_point)
		new_point = Vector3(leftSpawns.global_position.x, leftSpawns.global_position.y+1.1, new_point.z)
		var new_bartender = Bartender.instantiate()
		self.add_child(new_bartender)
		new_bartender.global_position = new_point

		new_bartender.target = (Vector3($"Right Gutter".global_position.x-50,
								new_bartender.global_position.y,
								new_bartender.global_position.z + randi_range(-30,30)))
		bartenders.append(new_bartender)
		$"Right Gutter".body_entered.connect(new_bartender.checkBarrier)
		
	await get_tree().create_timer(.33).timeout
	for b in bartenders:
		b.charge()

func addDifficulty():
	pass
	#TO-DO: Make this not empty
