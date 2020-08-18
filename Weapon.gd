extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_node("../Player")


var velocity=Vector3.ZERO
var shooting=false
var parent = null
func set_parent(newParent):
	parent=newParent
# Called when the node enters the scene tree for the first time.
func _ready():
	set_parent(player)
	#$AnimationPlayer.play("Hover")
	
func _process(delta):
	if(Input.is_action_just_pressed("lclick")):
		shoot(global_transform.origin.direction_to(player.global_transform.origin))

func _physics_process(delta):
	if shooting:
		if $RayCast.is_colliding():#when the knife hits something
			shooting=false
			velocity=Vector3()
			var collider = $RayCast.get_collider()
			if collider.is_in_group("enemies"):
				parent=collider
				parent.die()
				parent.WeaponPoint.global_transform = global_transform
			elif collider==player:
				parent=collider
		else:
			move_and_collide(velocity*delta) 
	elif parent!=null and (parent==player or parent.is_in_group("enemies")):
		global_transform = parent.WeaponPoint.global_transform
		#apply_central_impulse((plPos-myPos).normalized()*plPos.distance_to(myPos))
func shoot(vector):
	shooting=true
	velocity = vector.normalized()*50
	look_at(velocity,Vector3(0,1,0))
	parent=null
