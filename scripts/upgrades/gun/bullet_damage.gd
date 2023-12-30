extends Upgrade

@export var damage_mod: float

func apply_upgrade():
	gun.BULLET_DAMAGE *= damage_mod
