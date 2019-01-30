extends Control

func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_select"):
		Global.goto_scene("res://Scenes/Menu/StartMenu.tscn")
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()