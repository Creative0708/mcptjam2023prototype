extends Upgrade

func apply_upgrade():
	gun.BULLET_DAMAGE *= 0.9
	gun.DAMAGE_OVER_TIME += 5
