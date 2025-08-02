extends Node3D


@export var MachineAmount : int = 4
@export var OffsetTime : float = 0.5
@export var OffsetTimer : Timer
@export var Region3 : Area3D

var Machines : Array[SlotMachine]
var MachineOrder : Array[SlotMachine]
var CurrentMachine : SlotMachine


func _ready() -> void:
	for child in get_children():
		if child is SlotMachine:
			Machines.append(child)
	
	Region3.body_entered.connect(playerEntered)


func playerEntered(player : Player) -> void:
	if player is Player:
		
		
		for ListCount in MachineAmount:
			pass
		
