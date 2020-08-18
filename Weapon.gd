extends RigidBody


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
	set_parent(get_node("../Player"))
	#$AnimationPlayer.play("Hover")
	
func _process(delta):
	if parent==player and not shooting:
		if mode!=MODE_STATIC:
			mode=MODE_STATIC
		var plPos = player.WeaponPoint.global_transform.origin
		global_transform.origin = plPos
		#apply_central_impulse((plPos-myPos).normalized()*plPos.distance_to(myPos))
func shoot(vector):
	mode=MODE_RIGID
	shooting=true
	apply_central_impulse(vector.normalized()*60)
