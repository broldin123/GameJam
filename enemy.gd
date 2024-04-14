extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

var totalHealth = 10
var health = 10
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(_delta):
	deal_with_damage()
	
	if player_chase:
		position.x += (player.position.x + 3 - position.x)/speed
		
		if position.x >= 69:
			position.x = 69
		
		if position.x <=-60:
			position.x = -60
		
		if player_inattack_zone == true:
			$AnimatedSprite2D.play("side_attack")
		else:
			$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x <0):
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		



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


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		
		if can_take_damage == true:
			health = health - 1
			$take_damage_cooldown.start()
			can_take_damage = false
			print("hero health = ", health, " out of ", totalHealth)
			if health <= 0:
				$AnimatedSprite2D.play("death")
				self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
