extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_node("../Player")


var velocity=Vector3.ZERO
var shooting=false
var returning=false
var parent = null
func set_parent(newParent):
	parent=newParent
# Called when the node enters the scene tree for the first time.
func _ready():
	set_parent(player)
	#$AnimationPlayer.play("Hover")
	
func _process(delta):
	if(Input.is_action_just_pressed("lclick")):
		shoot(global_transform.origin.direction_to(player.WeaponPoint.global_transform.origin))
		returning=true

func _physics_process(delta):
	if shooting:
		if returning and global_transform.origin.distance_to(player.global_transform.origin)<3:
			parent=player
			shooting=false
			returning=false
		var collision = move_and_collide(velocity*delta)
		if collision==null:
			return
		var collider = collision.collider
		shooting=false
		returning=false
		velocity=Vector3()
		if collider.is_in_group("enemies"):
			$CollisionShape.set_disabled(true)
			parent=collider
			parent.die()
			parent.WeaponPoint.global_transform = global_transform
			
	elif parent!=null and (parent==player or parent.is_in_group("enemies")):
		global_transform = parent.WeaponPoint.global_transform
		#apply_central_impulse((plPos-myPos).normalized()*plPos.distance_to(myPos))
func shoot(vector):
	$CollisionShape.set_disabled(false)
	shooting=true
	velocity = vector.normalized()*50
	look_at(velocity,Vector3(0,1,0))
	parent=null
