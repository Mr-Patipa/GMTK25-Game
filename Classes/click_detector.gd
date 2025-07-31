extends Area3D
class_name ClickDetector

signal mouse_clicked

# Used for checking if the mouse is inside the Area3D.
var is_mouse_inside = false
# The last processed input touch/mouse event. To calculate relative movement.
var last_event_pos2D = null
# The time of the last event in seconds since engine start.
var last_event_time: float = -1.0


var MouseEvents : Array = [
	InputEventMouseButton,
	InputEventMouseMotion,
	InputEventScreenDrag,
	InputEventScreenTouch
	]

func _ready() -> void:
	mouse_entered.connect(_mouse_entered_area)
	mouse_exited.connect(_mouse_exited_area)


func _mouse_entered_area() -> void:
	is_mouse_inside = true


func _mouse_exited_area() -> void:
	is_mouse_inside = false


func _unhandled_input(event) -> void:
	# Check if the event is a non-mouse/non-touch event
	for mouse_event in MouseEvents:
		if is_instance_of(event, mouse_event):
			if is_mouse_inside and event is InputEventMouseButton:
				if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
					mouse_clicked.emit(self)
			return 
