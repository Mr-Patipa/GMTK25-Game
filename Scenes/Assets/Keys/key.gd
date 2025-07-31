extends Interactable

func activate(player : Player) -> void:
	get_parent().remove_child(self)
	player.get_node("Handle").add_child(self)
	position = Vector3.ZERO
	self["gravity_scale"] = 0
