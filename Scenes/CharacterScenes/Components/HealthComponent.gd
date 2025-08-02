extends Node
class_name HealthComponent

signal OnDeathed
signal OnDamaged
signal OnHealed

@export var MaxHealth := 100

var CurrentHp: int

func _ready() -> void:
	CurrentHp = MaxHealth

func heal(amount: int) -> void:
	CurrentHp += amount
	if CurrentHp >= MaxHealth:
		CurrentHp = MaxHealth
	
	OnHealed.emit()

func damage(amount: int) -> void:
	CurrentHp -= amount
	
	if CurrentHp <= 0:
		CurrentHp = 0
		OnDeathed.emit()
	else:
		OnDamaged.emit()
