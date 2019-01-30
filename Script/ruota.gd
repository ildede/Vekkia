extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var vecchia
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	vecchia =get_parent().get_parent()
	pass

func _process(delta):
	if vecchia.velocity.x != 0:
		transform = transform.rotated(vecchia.velocity.x * -0.0001)
