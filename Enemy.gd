extends KinematicBody

const MOVE_SPEED = 5

onready var raycast = $RayCast
onready var sprite = $Sprite3D
onready var animationPlayer = $AnimationPlayer
var player

func _ready():
	animationPlayer.play("idle")
	add_to_group("enemies")

func _physics_process(delta):
	if player==null:
		return
		
	var vec_to_player = player.translation-translation
	raycast.cast_to = vec_to_player*1.1
	vec_to_player = vec_to_player.normalized()
	if raycast.is_colliding() and raycast.get_collider()==player:
		animationPlayer.play("walk")
		move_and_collide(vec_to_player*MOVE_SPEED*delta)
		$SpriteHolder.rotation.y = PI/2-Vector2(vec_to_player.x,vec_to_player.z).angle()
	
func set_player(p):
	player=p
