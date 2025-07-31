extends Control
class_name infotabs

@export var ButtonsContainer : Control
@export var TabsContainer : Control
@export var InitialTab : Control


func _ready() -> void:
	Set_Up()


func Set_Up() -> void:
	InitialTab.visible = true
	
	for buttons in ButtonsContainer.get_children():
		if buttons is Button:
			buttons.pressed.connect(Global_Buttons_Handler.bind(buttons))
			


func Global_Buttons_Handler(buttons : Button) -> void:
	for tabs in TabsContainer.get_children():
		if tabs is Control:
			tabs.visible = false
	
	if buttons.name == "B1":
		TabsContainer.get_child(0).visible = true
	
	elif buttons.name == "B2":
		TabsContainer.get_child(1).visible = true
	
	elif buttons.name == "B3":
		TabsContainer.get_child(2).visible = true
	
	else:
		print("Something is wrong. Something is very Wrong...")
