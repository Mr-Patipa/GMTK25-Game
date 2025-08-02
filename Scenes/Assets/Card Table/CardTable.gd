extends AnimatableBody3D
class_name cardTable

@export var components: Array[Resource]

@export var path_follow: PathFollow3D
@export var follows_path = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if follows_path:
		assert(path_follow, "Moving card tables need a path assigned.")

	for c in components:
		if c.has_method("_ready"):
			c._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for c in components:
		if c.has_method("_process"):
			c._ready(delta)

func _physics_process(delta: float) -> void:
	$CollisionShape3D.global_position = self.global_position
	# Bug workaround. See https://github.com/godotengine/godot/issues/67257

func pathSetup() -> void:
	if self.path_follow == null: return
	self.reparent(path_follow)
