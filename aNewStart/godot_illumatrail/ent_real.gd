extends CharacterBody2D

var speedR = 125
var speedL = -125

##To chase the players
var player_chase = false
var player = null
var lock
@export var player_id = 1

##Testing the audio
var lostLive = false

##Health label
@onready var label = $LabelHealth
var health = 100
var player_alive = true

var enemy_inattack_range = false
var enemy_attack_cooldown = true

##Player number identified
var player1in = false
var player2in = false
var playerFriend = false


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	##What displays the health for the enemy
	label.text = "HP: " + str(health)
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if health <= 0:
		player_alive = false
		lostLive = true
		health = 0
		print ("Ent has been killed")
		queue_free()
		
	if player_alive == false && lostLive == true:
		lock == 50
		velocity.x = 0
		$death.play()

		

	enemy_attack()
	
	##Player chase mechanics
	if player_chase:
		
		if(player.position.x - position.x) < 0: 
			$AnimatedSprite2D.flip_h = true
		else: 
			$AnimatedSprite2D.flip_h = false
	else:
		if enemy_inattack_range == false:
			lock = 1
		velocity.x = 0
	
	##Run to the right
	if lock == 2:
		velocity.x = speedR
		
	if lock == 3:
		velocity.x = speedL 


	if velocity.x != 0 and lock != 5:
		$AnimatedSprite2D.play("Walk_%s" % [player_id])
	elif lock != 5:
		$AnimatedSprite2D.play("Idle_%s" % [player_id])
	
	if lock == 5:
		$AnimatedSprite2D.play("Attack_%s" % [player_id])
		print("Tree attack animation ran")
		$attackTitan.play()
	move_and_slide()



##Detection to the right
func _on_player_detector_body_entered(body):
	if lock != 5:
		$AnimatedSprite2D.play("Walk_%s" % [player_id])
	if body.name == "Player" || body.name == "Player2":
		player = body
		player_chase = true
		lock = 2

func _on_player_detector_body_exited(body):
	player = null
	player_chase = false

##Detection to the left
func _on_player_detector_l_body_entered(body):
	if lock != 5:
		$AnimatedSprite2D.play("Walk_%s" % [player_id])
	if body.name == "Player" || body.name == "Player2":
		player = body
		player_chase = true
		lock = 3

func _on_player_detector_l_body_exited(body):
	player = null
	player_chase = false

##So the heros beetles see it
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.name == "Player":
		enemy_inattack_range = true
		##Hurt animation
		###$AnimatedSprite2D.play("pain_%s" % [player_id])
		print("player 1 confirmed")
		player1in = true
		
	##Player2 identified
	if body.name == "Player2":
		enemy_inattack_range = true
		player2in = true
		##Hurt animation
		##$AnimatedSprite2D.play("pain_%s" % [player_id])
		print("player 2 confirmed")

	if body.has_method("player") || body.has_method("player_ally"):
		enemy_inattack_range = true
		
		##$AnimatedSprite2D.play("pain_%s" % [player_id])
		lock = 5

	##Players' friends identified
	if body.has_method("player_ally"):
		playerFriend = true
	if body.has_method("stung"):
		health = health - 45
		$painSo.play()
		

func enemy_attack():
	if enemy_inattack_range == true && enemy_attack_cooldown == true && Input.is_action_just_pressed("attack_1") && player1in == true:
		health = health - 20
		$attackTitan2.play()
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		$painSo.play()
		
		print(health)
		
		#Player 2 attack sense(Dawnspawn)
	elif enemy_inattack_range == true && enemy_attack_cooldown == true && Input.is_action_just_pressed("attack_2") && player2in == true:
		health = health - 20
		$attackTitan2.play()
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		$painSo.play()
		
		print(health)
		
		##Beetle attack sense
	elif enemy_inattack_range == true && Input.is_action_just_pressed("attack_2") && playerFriend == true:
		health = health - 10
		$attackTitan2.play()
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		$painSo.play()
		
		print(health)
	elif enemy_inattack_range == true && Input.is_action_just_pressed("attack_1") && playerFriend == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		$painSo.play()
		
		print(health)

##Leaves hitbox
func _on_enemy_hitbox_body_exited(body):
	if body.name == "Player":
		enemy_inattack_range = false
		print("player 1 ranaway")
		player1in = false

	if body.name == "Player2":
		enemy_inattack_range = false
		print("player 2 ranaway")
		player2in = false

	if body.has_method("player") || body.has_method("player_ally"):
		enemy_inattack_range = false

##Timer
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	print("Enemy lock:")
	print(lock)











func _on_death_finished():
	queue_free()


func _on_attack_cooldown_2_timeout():
	if player_alive == false:
		
		player_alive = true
		lostLive = false
