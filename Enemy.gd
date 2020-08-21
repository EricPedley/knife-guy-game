extends KinematicBody

const MOVE_SPEED = 5
const acceleration = 1
onready var raycast = $RayCast
onready var sprite = $Sprite3D
onready var animationPlayer = $AnimationPlayer
onready var WeaponPoint = $CollisionShape/Sprite3D/WeaponPoint

var ragdollScene = preload("res://EnemyRagdoll.tscn")
var player
var dead = false

func _ready():
	add_to_group("enemies")
	#set_mode(MODE_CHARACTER)

func _physics_process(delta):
	if player==null:
		return
	if not dead:	
		var vec_to_player = player.translation-translation
		raycast.cast_to = vec_to_player*1.1
		vec_to_player = vec_to_player.normalized()
		if raycast.is_colliding() and raycast.get_collider()==player:
			animationPlayer.play("walk")
		#set_linear_velocity(Vector3())
		#apply_central_impulse(vec_to_player * MOVE_SPEED)
		move_and_collide(vec_to_player*MOVE_SPEED*delta)
		$CollisionShape.rotation.y = PI/2-Vector2(vec_to_player.x,vec_to_player.z).angle()
	
func set_player(p):
	player=p
	
func die():
	print("rip")
	var ragdollInstance = ragdollScene.instance()
	for child in get_children():
		ragdollInstance.add_child(child.duplicate())
	ragdollInstance.global_transform=global_transform
	get_parent().add_child(ragdollInstance)
	queue_free()
	return ragdollInstance
