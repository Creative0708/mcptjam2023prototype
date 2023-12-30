extends Upgrade

@export var cooldown_mod: float

func apply_upgrade():
	gun.COOLDOWN_TIME *= cooldown_mod
