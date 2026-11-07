class_name Farm
extends Node2D

@onready var field: Field = $ColorRect/field_aspect/field

func _ready():
	field.cell_clicked.connect(_on_cell_clicked)
	field.cell_hovered.connect(_on_cell_hovered)


func _on_cell_clicked(cell: Vector2i):
	print("Clicked cell: ", cell)


func _on_cell_hovered(cell: Vector2i):
	print("Hovered cell: ", cell)
