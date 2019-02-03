extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 500.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 1600
const WALK_MIN_SPEED = 30
const WALK_MAX_SPEED = 1200
const STOP_FORCE = 60
const JUMP_SPEED = 600
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var wheelchair
var lastWheelSpin
var risataVekkia
var collisionOnMetalPlayer
var laVekkiaMuore
var laVekkiaSpaccaLePlacche
var screensize
var wheelchairIteration
var metalHornsEnable = false
var hornCaller
var legsIteration = 20
var released = true

var prev_jump_pressed = false

var input_enable = true

func _ready():
	screensize = get_viewport_rect().size
	wheelchair = AudioStreamPlayer.new()
	wheelchair.volume_db = -10
	self.add_child(wheelchair)

	collisionOnMetalPlayer = AudioStreamPlayer.new()
	collisionOnMetalPlayer.autoplay = false
	self.add_child(collisionOnMetalPlayer)

	risataVekkia = AudioStreamPlayer.new()
	risataVekkia.autoplay = false
	risataVekkia.volume_db = 3
	self.add_child(risataVekkia)

	lastWheelSpin = AudioStreamPlayer.new()
	lastWheelSpin.autoplay = false
	self.add_child(lastWheelSpin)

	laVekkiaMuore = AudioStreamPlayer.new()
	laVekkiaMuore.autoplay = false
	self.add_child(laVekkiaMuore)

	laVekkiaSpaccaLePlacche = AudioStreamPlayer.new()
	laVekkiaSpaccaLePlacche.autoplay = false
	laVekkiaSpaccaLePlacche.volume_db = -5
	self.add_child(laVekkiaSpaccaLePlacche)

	wheelchair.stream = load("res://AudioEffects/wheelchair_effect.wav")
	collisionOnMetalPlayer.stream = load("res://AudioEffects/no_no.wav")
	risataVekkia.stream = load("res://AudioEffects/suono_risata_vekkia_02.wav")
	lastWheelSpin.stream = load("res://AudioEffects/last_spin.wav")
	laVekkiaMuore.stream = load("res://AudioEffects/suono_morte_vekkia.wav")
	laVekkiaSpaccaLePlacche.stream = load("res://AudioEffects/suono_lamiera_acuta.wav")
	wheelchairIteration = 0

func _enable_metal_horns(caller):
	if input_enable:
		metalHornsEnable = true
		hornCaller = caller

func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	#var walk_left = Input.is_action_pressed("ui_left")
	
	var walk_right = Input.is_action_pressed("ui_select")

	
	#var jump = Input.is_action_pressed("button_jump")
	
	var stop = true
	
	#if walk_left:
	#	if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
	#		force.x -= WALK_FORCE
	#		stop = false
	if walk_right && released && input_enable:
		wheelchairIteration = 0
		if (!wheelchair.playing):
			wheelchair.play()
		if (!get_node("AnimationPlayer").is_playing()):
			get_node("AnimationPlayer").play("Anim_Push")
		released = false
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	released = !walk_right
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	
	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	#if jumping and velocity.y > 0:		
		# If falling, no longer jumping
	#	jumping = false
	
	
	#if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
	#	# Jump must also be allowed to happen if the character left the floor a little bit ago.
	#	# Makes controls more snappy.
	#	velocity.y = -JUMP_SPEED
	#	jumping = true
	
	
	
	#on_air_time += delta
	#prev_jump_pressed = jump
	
	############Animazioni###############

	if is_on_wall() && input_enable:
		legsIteration = 0
		get_node("Sprite_Frame/corpo_normale").visible = false
		get_node("Sprite_Frame/corpo_gambe_alzate").visible = true
		if (!collisionOnMetalPlayer.playing):
			collisionOnMetalPlayer.play()
	elif (legsIteration > 20):
		get_node("Sprite_Frame/corpo_normale").visible = true
		get_node("Sprite_Frame/corpo_gambe_alzate").visible = false
	else:
		legsIteration += 1

	var braccio = get_node("Sprite_Frame/Position2D/braccio_iella")
	if (metalHornsEnable):
		if braccio.transform.get_rotation() < 0:
		 	braccio.transform = braccio.transform.rotated(0.05)
		else:
			laVekkiaSpaccaLePlacche.play()
			hornCaller._kill_Yourself_Please()
			metalHornsEnable = false
			get_node("AnimationPlayer").play("Anim_Laughter")
			
			risataVekkia.play()
	elif (braccio.transform.get_rotation() > deg2rad(-52)):
		braccio.transform = braccio.transform.rotated(-0.01)

	
	if (wheelchairIteration > 60):
		wheelchair.stop()
		wheelchairIteration = 0
	else:
		wheelchairIteration += 1

func pls_seppuku():
	input_enable = false
	lastWheelSpin.play(7)
	laVekkiaMuore.play()
	get_node("AnimationPlayer").play("Anim_Death")
	