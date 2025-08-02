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
		new_point = Vector3(rightSpawns.position.x, rightSpawns.position.y, new_point.z)

		var new_bartender = Bartender.instantiate()

		new_bartender.position = new_point
		self.add_child(new_bartender)
		var target = (Vector3($"Left Gutter".position.x + randi_range(-5,5),
									new_bartender.position.y,
									new_bartender.position.z))
		
		# new_bartender.charge(target)
		
	for p in left_pos:
		var new_point = leftSpawns.curve.sample_baked(p*leftSpawns.curve.get_baked_length())
		new_point = Vector3(leftSpawns.position.x, leftSpawns.position.y, new_point.z)
		var new_bartender = Bartender.instantiate()
		
		new_bartender.position = new_point
		self.add_child(new_bartender)

		var target = look_at(Vector3($"Right Gutter".position.x + randi_range(-5,5),
								new_bartender.position.y,
								new_bartender.position.z))
		
		# new_bartender.charge(target)
