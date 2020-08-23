extends KinematicBody

const MOVE_SPEED =10
const MOUSE_SENS = 0.5
const GRAVITY = 1
const ACCELERATION=20
const JUMP = 15
onready var WeaponPoint = $Head/WeaponPoint
onready var head = $Head
var health = 12
var moving=true
var velocity = Vector3()
var fall = Vector3()
var jumping=false
#https://www.youtube.com/watch?v=DMc641-k9B8&ab_channel=WhiteBatAudio maybe use this as audio?
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(),"idle_frame")
	get_tree().call_group("enemies","set_player",self);

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS*event.relative.x
		var newRotationDegrees = head.rotation_degrees.x - MOUSE_SENS*event.relative.y
		if(newRotationDegrees<90&&newRotationDegrees>-90):
			head.rotation_degrees.x = newRotationDegrees
	
func _process(delta):
	if(Input.is_action_pressed("exit")):
		get_tree().quit()
	if(Input.is_action_just_pressed("rclick")):
		var dagger = get_node("../Dagger")
		var aimDir = dagger.global_transform.origin.direction_to($Head/RayCast.get_collision_point())
		dagger.shoot(aimDir)
		dagger.set_visible(true)
		$Head/WeaponPoint/DaggerSprite.set_visible(false)
		$KnifeThrowSound.play()
	if(Input.is_action_just_pressed("lclick")):
		var dagger = get_node("../Dagger")
		dagger.shoot(dagger.global_transform.origin.direction_to(WeaponPoint.global_transform.origin))
		dagger.returning=true
	
func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("forward"):
		move_vec.z-=1
	if Input.is_action_pressed("backward"):
		move_vec.z+=1
	if Input.is_action_pressed("left"):
		move_vec.x-=1
	if Input.is_action_pressed("right"):
		move_vec.x+=1
	move_vec = move_vec.normalized();
	if(move_vec!=Vector3()):
		if(not moving):
			moving=true
			$Running.play()
	else:
		moving=false
		$Running.stop()
	move_vec = move_vec.rotated(Vector3(0,1,0),rotation.y)
	velocity=velocity.move_toward(move_vec*MOVE_SPEED,ACCELERATION)
	if not is_on_floor():
		fall.y-=GRAVITY
	else:
		fall.y=-1
	if(is_on_floor() and Input.is_action_just_pressed("jump")):
		fall.y=JUMP
	velocity=move_and_slide(velocity,Vector3.UP)
	move_and_slide(fall,Vector3.UP)
		
func show_dagger():
	$Head/WeaponPoint/DaggerSprite.set_visible(true)
