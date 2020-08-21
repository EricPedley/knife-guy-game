extends RigidBody

const IS_RAGDOLL = true

onready var WeaponPoint = $WeaponPoint
func _ready():
	#set_angular_damp(0.999)
	set_mass(10)

func go_flying(origin, direction):
	apply_impulse(origin, direction/10)
	apply_impulse(Vector3(0,0.1,0),direction)
