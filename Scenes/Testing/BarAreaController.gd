extends Node

@export var Bartender: PackedScene

var rightSpawns: Path3D
var leftSpawns: Path3D

func _ready() -> void:
	rightSpawns = $"Right Spawns"
	leftSpawns = $"Left Spawns"
	spawn_bartenders()
	

func spawn_bartenders():
	var right_pos = []
	var left_pos = []
	var bartenders = []
	
	right_pos.append(randf_range(0,.2))
	right_pos.append(randf_range(.2,.4))
	right_pos.append(randf_range(.4,.6))
	right_pos.append(randf_range(.6,.8))
	right_pos.append(randf_range(.8,1.0))
	
	left_pos.append(randf_range(0,.2))
	left_pos.append(randf_range(.2,.4))
	left_pos.append(randf_range(.4,.6))
	left_pos.append(randf_range(.6,.8))
	left_pos.append(randf_range(.8,1.0))
	
	for p in right_pos:
		var new_point = rightSpawns.curve.sample_baked(p*rightSpawns.curve.get_baked_length())
		new_point = Vector3(rightSpawns.position.x, rightSpawns.position.y+1.1, new_point.z)

		var new_bartender = Bartender.instantiate()

		new_bartender.position = new_point
		self.add_child(new_bartender)
		new_bartender.target = (Vector3($"Left Gutter".position.x + randi_range(-5,5),
									new_bartender.position.y,
									new_bartender.position.z))
		bartenders.append(new_bartender)

		
	for p in left_pos:
		var new_point = leftSpawns.curve.sample_baked(p*leftSpawns.curve.get_baked_length())
		new_point = Vector3(leftSpawns.position.x, leftSpawns.position.y+1.1, new_point.z)
		var new_bartender = Bartender.instantiate()
		
		new_bartender.position = new_point
		self.add_child(new_bartender)

		new_bartender.target = (Vector3($"Right Gutter".position.x + randi_range(-5,5),
								new_bartender.position.y,
								new_bartender.position.z))
		bartenders.append(new_bartender)
		
	await get_tree().create_timer(.33).timeout
	for b in bartenders:
		b.charge()
