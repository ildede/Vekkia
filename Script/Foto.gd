extends CenterContainer

func _ready():
	pass

func set_photo(path):
	get_node("TextureRect").texture = path