extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var projectile = $Projectile
onready var rayCast = $Projectile/RayCast
var velocity=Vector3.ZERO
var shooting=false
var parent = null
func set_parent(newParent):
	parent=newParent
# Called when the node enters the scene tree for the first time.
func _ready():
	set_parent(get_node("../Player"))
	$AnimationPlayer.play("Hover")
func _physics_process(delta):
	if($Projectile!=null):
		print($Projectile)
		$Projectile.translation = parent.translation + Vector3(0.5,0.5,-1).rotated(Vector3(1,0,0),parent.rotation.x).rotated(Vector3(0,1,0),parent.rotation.y)
		$Projectile.rotation.y = parent.rotation.y+PI/2
	if shooting:
		$Projectile.move_and_collide(velocity*delta)
		if rayCast.is_colliding():
			shooting=false
			velocity=Vector3.ZERO
			var impactPoint = rayCast.get_collision_point()
			$AnimationPlayer.play("still")
			rayCast.get_collider().add_child(duplicate())
			get_parent().remove_child(self);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func shoot(vector):
	shooting=true
	velocity = vector.normalized()*500
