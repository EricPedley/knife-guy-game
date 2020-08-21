extends KinematicBody

const MOVE_SPEED = 5
const acceleration = 1
onready var raycast = $RayCast
onready var sprite = $Sprite3D
onready var animationPlayer = $AnimationPlayer
onready var WeaponPoint = $WeaponPoint

var ragdollScene = preload("res://EnemyRagdoll.tscn")
var player
var dead = false
var health = 1
var following = false

func _ready():
	add_to_group("enemies")
	#set_mode(MODE_CHARACTER)

func _physics_process(delta):
	if player==null:
		return
	if not dead:	
		var vec_to_player = player.translation-translation
		raycast.cast_to = vec_to_player.rotated(Vector3.UP,-rotation.y)*1.1
		if raycast.is_colliding() and raycast.get_collider()==player:
			if(following==false):
				vec_to_player.y=-50
			following=true
			animationPlayer.play("walk")
			if vec_to_player.length()<5:
				pass
				#print(translation)
			vec_to_player = vec_to_player.normalized()
			move_and_collide(vec_to_player*MOVE_SPEED*delta)
			rotation.y = PI/2-Vector2(vec_to_player.x,vec_to_player.z).angle()
		else:
			following=false
	
func set_player(p):
	player=p
	
func get_hit():
	$BloodAnimationPlayer.play("Splurt")
	health-=1
	$CPUParticles.global_transform = $WeaponPoint.global_transform
	$CPUParticles.set_emitting(true)
	if health<1:
		return die()
	else:
		return self

func die():
	print("rip")
	var ragdollInstance = ragdollScene.instance()
	for child in get_children():
		ragdollInstance.add_child(child.duplicate())
	ragdollInstance.global_transform=global_transform
	get_parent().add_child(ragdollInstance)
	queue_free()
	return ragdollInstance
