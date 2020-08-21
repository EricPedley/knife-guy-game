extends RigidBody

const IS_RAGDOLL = true

onready var WeaponPoint = $WeaponPoint
func _ready():
	set_angular_damp(-30)
	set_mass(10)

func go_flying(origin, direction):
	apply_impulse(origin, direction)
