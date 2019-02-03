extends Container

var the_end = false

func _ready():
	get_node("SlowTrigger").connect("body_entered", self, "_on_slow_trigger_entered")
	get_node("EndTrigger").connect("body_entered", self, "_on_end_trigger_entered")
	get_node("StopCameraTrigger").connect("body_entered", self, "_on_stopcam_trigger_entered")
	get_node("BuriedTrigger").connect("body_entered", self, "_on_buried_trigger_entered")

	$Vecchina/AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

	$Vecchina/Camera2D/Restart.connect("pressed", self, "on_restart_clicked")

	$BuriedTrigger/baloon/AnimationPlayer.connect("animation_finished", self, "_on_BaloonAnimationPlayer_animation_finished")

func _process(delta):
	if Input.is_action_pressed("ui_select") && the_end:
		Global.goto_scene("res://Scenes/TheEnd/TheEnd.tscn")

func _on_slow_trigger_entered(body):
	get_node("Vecchina/Camera2D/DeathCountdown").slow()

func _on_stopcam_trigger_entered(body):
	$CameraEnd.global_position = $Vecchina/Camera2D.global_position
	$Vecchina/Camera2D/Frame.visible = false
	$CameraEnd/Frame.visible = true
	$CameraEnd.current = true

func _on_end_trigger_entered(body):
	$Vecchina.input_enable = false
	get_node("Vecchina/Camera2D/NewDeathCountdown").stop()
	$Tomba/FloorTomba/CollisionShape2D.disabled = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if ( anim_name == "Anim_Death" ):
		$Vecchina/Camera2D/Restart.visible = true

func on_restart_clicked():
	Global.goto_scene("res://Scenes/BaseLevel/Level.tscn")

func _on_BaloonAnimationPlayer_animation_finished(anim_name):
	if ( anim_name == "Anim_BaloonRise" ):
		print("the end true")
		the_end = true
	pass

func _on_buried_trigger_entered(body):
	$BuriedTrigger/baloon/AnimationPlayer.play("Anim_BaloonRise")
