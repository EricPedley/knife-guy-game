extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(4)
	timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	get_tree().change_scene("res://MainMenu.tscn")
