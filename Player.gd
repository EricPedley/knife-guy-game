extends KinematicBody

const MOVE_SPEED =10
const MOUSE_SENS = 0.5
onready var WeaponPoint = $WeaponPoint
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(),"idle_frame")
	get_tree().call_group("enemies","set_player",self);

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS*event.relative.x
		var newRotationDegrees = rotation_degrees.x - MOUSE_SENS*event.relative.y
		if(newRotationDegrees<90&&newRotationDegrees>-90):
			rotation_degrees.x = newRotationDegrees
	
func _process(delta):
	if(Input.is_action_pressed("exit")):
		get_tree().quit()
	if(Input.is_action_just_pressed("rclick")):
		var aimDir 
		if($RayCast.is_colliding()):
			var destination = $RayCast.get_collision_point()
			aimDir = $WeaponPoint.global_transform.origin.direction_to(destination)
		else:
			aimDir = Vector3(0,0,-1).rotated(Vector3(0,1,0),rotation.y)
		get_node("../Dagger").shoot(aimDir)
	
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
	move_vec = move_vec.rotated(Vector3(0,1,0),rotation.y)
	move_and_collide(move_vec*MOVE_SPEED*delta)
	
