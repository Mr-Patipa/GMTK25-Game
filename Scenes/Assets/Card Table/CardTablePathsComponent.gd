extends Node
class_name CardTablePathsComponent

var pathUpdateRate = 1.0/12000

var old_position = Vector3(0,0,0) # Used to update parent velocity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var p : cardTable = self.get_parent()
	if not p.follows_path: return
	var pp : PathFollow3D = self.get_parent().get_parent()
	var curve : Curve3D = pp.get_parent().curve
	var new_progress = null
	
	# Update velocity of parent
	
	# Update progress_rate
	
	# Will put us at a PathFollow3D when using this component node
	if pp.get("progress_ratio") != null:
		new_progress = (pp.progress_ratio + pathUpdateRate)
		p.constant_linear_velocity = (curve.sample_baked(pp.progress,pp.cubic_interp) - old_position)/delta
		old_position = curve.sample_baked(pp.progress,pp.cubic_interp)
		
		while new_progress > 1:
			new_progress = new_progress - 1
		pp.progress_ratio = new_progress
		
