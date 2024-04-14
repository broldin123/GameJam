extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null


var totalHealth = 5
var curHealth = 5
var player_inattack_zone = false
var can_take_damage = true

#TODO: This scene automatically starts when you play the game
#The game should begin with the human summoning you
#Dialogue beforehand with adventurer explaining that he wishes to fight you
#Adventurer should be invisible before first interaction

var timeUntilSummon = 30

func _physics_process(_delta):
	#$Label2.set_text("Summoning: " +str($SummoningTimer2.get_time_left()))
	deal_with_damage()
	#$PortalToHome2.visible = false 
	#$PortalToHome2.position.y = 12
	#$PortalToHome2.position.x = -10
	
	if global.isWorkActive and global.workPlayer != null and global.workPlayer.position != null and curHealth > 0: #TODO: The human shouldn't be on top of the skeleton once the human catches the skeleton
		var distToAttack = 13
		
		var distToPlayer = global.workPlayer.position.distance_to(position)
		#print("Dist to player: ", distToPlayer)
		
		if distToPlayer > distToAttack:
			position += (global.workPlayer.position - position)/speed
		
		if position.x >= 69:
			position.x = 69
		
		if position.x <=-60:
			position.x = -60
			
		#if position.x = global.workPlayer.position.x:
		#	position.x
		
		if player_inattack_zone == true:
			$AnimatedSprite2D.play("side_attack")
		else:
			$AnimatedSprite2D.play("walk")
			
		if(global.workPlayer.position.x - position.x <0):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _process(delta):
	if !visible:
		$Label2.set_text("")
	
	if visible and !global.isWorkActive:
		timeUntilSummon -= delta
		print( "TimeUntilSummon: ", timeUntilSummon)
		if timeUntilSummon < 11 and timeUntilSummon > 0:
			$Label2.set_text("Summoning: " + str(int(timeUntilSummon)) )
		else:
			$Label2.set_text("")
			
		if timeUntilSummon < 0:
			global.SetPlayer(true)
			var min_value = 17.0
			var max_value = 33.0
			var random_float = randf() * (max_value - min_value) + min_value		
			timeUntilSummon = random_float
		
		
	if global.adventurerNeedsRespawn:
		global.adventurerNeedsRespawn = false
		$respawn_Enemy_Timer.start()

func _ready():
	global.adventurer = self;

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true


#func _on_enemy_hitbox_body_exited(body):
#	if body.has_method("player"):
#		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		
		if can_take_damage == true:
			curHealth = curHealth - 1
			$take_damage_cooldown.start()
			can_take_damage = false
			var healthPercent = 100 - (float(curHealth) / totalHealth) * 100
			print("hero health = ", curHealth, " out of ", totalHealth, " - Percent: ", healthPercent)
			
			if( global.adventureProgress != null ):
				global.adventureProgress.SetProgressPercent( healthPercent)
				
			if curHealth <= 0:
				$AnimatedSprite2D.play("death")
				#$PortalToHome2.visible = true 
				#TODO: This portal should appear when the human is defeated! 
				#The skeleton will be able to return home via the portal
				#When the skeleton goes through the portal, the human should respawn and begin summoning the skeleton again (15 seconds)
				print("enemy is dead")
				$AnimatedSprite2D.visible = false
				player_chase = false
				global.ShowPortalToHome()
				

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_respawn_enemy_timer_timeout():
	curHealth = totalHealth
	position.x = -60
	$AnimatedSprite2D.visible = true
	print("enemy is back")
	$BeginAttackRespawn.start()
	$SummoningTimer2.start()
	

#func _on_begin_attack_respawn_timeout(body):
	
	

func _on_summoning_timer_2_timeout():
	#TODO: When this timer runs out, the skeleton should be summoned to the work world to fight the human
	#There probably needs to be some sort of animation with the player summmoning - right now he is idle next to the altar
	pass # Replace with function body.
