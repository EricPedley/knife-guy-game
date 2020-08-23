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
var fall = Vector3()
var damage=40
var attackCooldown=100
var attackCooldownMax=100

func _ready():
	add_to_group("enemies")
	#set_mode(MODE_CHARACTER)

func _physics_process(delta):
	if(attackCooldown<100):
		attackCooldown+=1
	if player==null:
		return
	if not dead:	
		if attackCooldown>=100 and $AttackRange.is_colliding() and $AttackRange.get_collider()==player:
			$AnimationPlayer2.play("attack")
			$Punch.play()
			player.take_damage(damage)
			attackCooldown=0
		var vec_to_player = player.translation-translation
		raycast.cast_to = vec_to_player.rotated(Vector3.UP,-rotation.y)*1.1
		if raycast.is_colliding() and raycast.get_collider()==player and global_transform.origin.distance_to(player.global_transform.origin)>1.5:
			if(following==false):
				vec_to_player.y=-50
			following=true
			animationPlayer.play("walk")
			if vec_to_player.length()<5:
				pass
				#print(translation)
			vec_to_player = vec_to_player.normalized()
			var on_floor=false
			if not is_on_floor():
				fall.y-=1
			else:
				fall.y=-1
			if is_on_floor():
				on_floor=true
			move_and_slide(Vector3(vec_to_player.x,0,vec_to_player.z)*MOVE_SPEED,Vector3.UP)
			if on_floor and is_on_wall():
				fall.y=15
			move_and_slide(fall,Vector3.UP)
			rotation.y = PI/2-Vector2(vec_to_player.x,vec_to_player.z).angle()
		else:
			animationPlayer.stop()
			following=false
	
func set_player(p):
	player=p
	
func get_hit():
	$StabSound.play()
	$BloodAnimationPlayer.play("Splurt")
	health-=1
	$CPUParticles.global_transform = $WeaponPoint.global_transform
	#$CPUParticles.set_emitting(true)
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
