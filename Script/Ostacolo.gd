extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("braccio_normale").connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	get_parent().get_node("Vecchina")._enable_metal_horns(self)

func _kill_Yourself_Please():
	#rotation = 0
	$Position2D/Decorazione.visible = true
	$Position2D/Decorazione/AnimationPlayer.play("Anim_Grow")
	remove_child($CollisionShape2D)
	remove_child($CollisionShape2D2)
	remove_child($braccio_normale)
	
	#get_parent().remove_child(self)


