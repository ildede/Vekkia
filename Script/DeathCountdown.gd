extends Node

var timer = null
var countdownLabel = null
var heart1 = null
var heart2 = null
var maxTimeParam = 45
var heartSpeedParam = 3
var deltaSum = 0
var slowed = false

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_bad_death") 
	timer.set_wait_time(maxTimeParam)
	add_child(timer)
	timer.start()
	
	countdownLabel = get_node("CountdownLabel")
	heart1 = get_node("Heart1")
	heart2 = get_node("Heart2")
	heart1.visible = true
	heart2.visible = false

func _process(delta):
	deltaSum += delta
	var left_time = timer.get_time_left()
	var heartSpeed = heartSpeedParam * left_time/maxTimeParam #0:heartSpeed
	
	if (not slowed):
		countdownLabel.set_text(str(int(left_time)))
	elif ( int(left_time) % 2 == 0):
		countdownLabel.set_text(str(int(left_time) / 2))
	
	if ( left_time != 0 and deltaSum > heartSpeed ):
		heart1.visible = !heart1.visible
		heart2.visible = !heart2.visible
		deltaSum = 0

func _bad_death():
	timer.stop()
	get_parent().get_parent().pls_seppuku()

func stop():
	timer.stop()
	self.visible = false

func slow():
	var t = timer.get_time_left()
	timer.stop()
	
	timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(int(t)*2)
	timer.start()
	slowed = true
