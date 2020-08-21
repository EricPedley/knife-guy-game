extends RigidBody


onready var WeaponPoint = $WeaponPoint
func _ready():
	set_angular_damp(-15)
	set_mass(10)

func go_flying(origin, direction):
	apply_impulse(origin, direction/10)
