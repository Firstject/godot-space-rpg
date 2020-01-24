extends PlayerWeaponCore

#-------------------------------------------------
#      Override Methods
#-------------------------------------------------

func _fire():
	AudioCenter.pshot_normal.play()
	
	match get_current_beam_lv():
		1:
			lv1()
		2:
			lv2()
		3:
			lv3()
		4:
			lv4()
		5:
			lv5()
		6:
			lv6()
		7:
			lv7()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func lv1():
	spawn_projectile()

func lv2():
	var proj1 = spawn_projectile()
	proj1.position.x -= 3
	var proj2 = spawn_projectile()
	proj2.position.x += 3

func lv3():
	var proj1 = spawn_projectile()
	proj1.position.x -= 5
	proj1.bullet_behavior.angle_in_degrees -= 8
	var proj2 = spawn_projectile()
	proj2.position.x += 5
	proj2.bullet_behavior.angle_in_degrees += 8
	
	var proj3 = spawn_projectile()
	proj3.position.x -= 3
	var proj4 = spawn_projectile()
	proj4.position.x += 3

func lv4():
	var proj1 = spawn_projectile()
	proj1.position.x -= 5
	proj1.bullet_behavior.angle_in_degrees -= 8
	var proj2 = spawn_projectile()
	proj2.position.x += 5
	proj2.bullet_behavior.angle_in_degrees += 8
	
	var proj3 = spawn_projectile()
	proj3.position.y -= 3
	var proj4 = spawn_projectile()
	proj4.position.x -= 5
	var proj5 = spawn_projectile()
	proj5.position.x += 5

func lv5():
	var proj1 = spawn_projectile()
	proj1.position.x -= 4
	proj1.bullet_behavior.angle_in_degrees -= 6
	var proj2 = spawn_projectile()
	proj2.position.x += 4
	proj2.bullet_behavior.angle_in_degrees += 6
	var proj3 = spawn_projectile()
	proj3.position.x -= 4
	proj3.bullet_behavior.angle_in_degrees -= 10
	var proj4 = spawn_projectile()
	proj4.position.x += 4
	proj4.bullet_behavior.angle_in_degrees += 10
	
	var proj5 = spawn_projectile()
	proj5.position.y -= 3
	var proj6 = spawn_projectile()
	proj6.position.x -= 5
	var proj7 = spawn_projectile()
	proj7.position.x += 5

func lv6():
	var proj1 = spawn_projectile()
	proj1.position.x -= 5
	proj1.bullet_behavior.angle_in_degrees -= 6
	var proj2 = spawn_projectile()
	proj2.position.x += 5
	proj2.bullet_behavior.angle_in_degrees += 6
	var proj3 = spawn_projectile()
	proj3.position.x -= 5
	proj3.bullet_behavior.angle_in_degrees -= 10
	var proj4 = spawn_projectile()
	proj4.position.x += 5
	proj4.bullet_behavior.angle_in_degrees += 10
	
	var proj5 = spawn_projectile()
	proj5.position += Vector2(-2, -3)
	var proj6 = spawn_projectile()
	proj6.position += Vector2(2, -3)
	var proj7 = spawn_projectile()
	proj7.position.x += 7
	var proj8 = spawn_projectile()
	proj8.position.x -= 7

func lv7():
	var proj1 = spawn_projectile()
	proj1.position.x -= 5
	proj1.bullet_behavior.angle_in_degrees -= 6
	var proj2 = spawn_projectile()
	proj2.position.x += 5
	proj2.bullet_behavior.angle_in_degrees += 6
	var proj3 = spawn_projectile()
	proj3.position.x -= 5
	proj3.bullet_behavior.angle_in_degrees -= 10
	var proj4 = spawn_projectile()
	proj4.position.x += 5
	proj4.bullet_behavior.angle_in_degrees += 10
	
	var proj5 = spawn_projectile()
	proj5.position += Vector2(-2, -3)
	var proj6 = spawn_projectile()
	proj6.position += Vector2(2, -3)
	var proj7 = spawn_projectile()
	proj7.position.x += 7
	var proj8 = spawn_projectile()
	proj8.position.x -= 7
	
	var proj9 = spawn_projectile()
	proj9.position += Vector2(-5, -3)
	proj9.bullet_behavior.speed *= 1.3
	var proj10 = spawn_projectile()
	proj10.position += Vector2(5, -3)
	proj10.bullet_behavior.speed *= 1.3

