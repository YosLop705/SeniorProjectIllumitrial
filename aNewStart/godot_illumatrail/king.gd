extends CharacterBody2D

var speedR = 245
var speedL = -250

##To chase the players
var player_chase = false
var player = null
var lock
@export var player_id = 1
var lock2 = 30

##Health label
@onready var label = $LabelHealth
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
var health = 450
var player_alive = true

var enemy_inattack_range = false
var enemy_attack_cooldown = true

##Player number identified
var player1in = false
var player2in = false
var playerFriend = false

var detectJ = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	##What displays the health for the enemy
	label.text = "BOSSS HP: " + str(health)
	if not is_on_floor():
		velocity.y += gravity * delta
	
	enemy_attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print ("Ent has been killed")
		lock = 30
		lock2 = 25
	
	##Player chase mechanics
	if player_chase && lock2 != 25:
		
		if(player.position.x - position.x) < 0: 
			$AnimatedSprite2D.flip_h = true
		else: 
			$AnimatedSprite2D.flip_h = false
	elif lock2 != 25 && player_chase == false && detectJ == 0:
		if enemy_inattack_range == false:
			print("")
			##lock = 1
	
	##Run to the right
	if lock == 2:
		velocity.x = speedR
		
	if lock == 3:
		velocity.x = speedL 

	if velocity.x != 0 and lock != 5 and lock2 != 25:
		$AnimatedSprite2D.play("Walk_%s" % [player_id])
	elif velocity.x == 0 and lock != 5 and lock2 != 25 and is_on_floor():
		$AnimatedSprite2D.play("Idle_%s" % [player_id])
	
	if lock2 == 25 && player_alive == false:
		$AnimatedSprite2D.play("pain_%s" % [player_id])
		print("Tree hurt animation ran")
		$death.play()
		
	if lock == 5 and lock2 !=25:
		$AnimatedSprite2D.play("Attack_%s" % [player_id])
	
	if Input.is_action_just_pressed("jump_1") || Input.is_action_just_pressed("jump_2"):
		if detectJ == 2:
			print("KING HAS FLAPPED")
			lock2 = 25
			lock = 77
			$AnimatedSprite2D.play("Jump_%s" % [player_id])
	
	if lock2 == 25 && player_alive == true && detectJ == 2:
		velocity.y = -385
		lock2 = 20
	if not is_on_floor():
		$AnimatedSprite2D.play("Jump_%s" % [player_id])
	move_and_slide()



##Detection to the right
func _on_player_detector_body_entered(body):
	if lock != 5 and lock2 !=25:
		$AnimatedSprite2D.play("Walk_%s" % [player_id])
	if body.name == "Player" || body.name == "Player2":
		if lock2 !=25:
			player = body
			player_chase = true
			lock = 2

func _on_player_detector_body_exited(body):
	player = null
	player_chase = false

##Detection to the left
func _on_player_detector_l_body_entered(body):
	if lock != 5 and lock2 !=25:
		$AnimatedSprite2D.play("Walk_%s" % [player_id])
	if body.name == "Player" || body.name == "Player2":
		if lock2 != 25:
			player = body
			player_chase = true
			lock = 3

func _on_player_detector_l_body_exited(body):
	player = null
	player_chase = false

##So the heros beetles see it
func enemy():
	pass

##To deal extra damage
func royalTree():
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
		if lock2 !=25:
			enemy_inattack_range = true
			
			##$AnimatedSprite2D.play("pain_%s" % [player_id])
			lock = 5

	##Players' friends identified
	if body.has_method("player_ally"):
		playerFriend = true
	if body.has_method("stung"):
		health = health - 45

func enemy_attack():
	##if enemy_inattack_range == true && enemy_attack_cooldown == true && Input.is_action_just_pressed("attack_1") && player1in == true:
	if enemy_inattack_range == true && Input.is_action_just_pressed("attack_1") && player1in == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)
		
		#Player 2 attack sense(Dawnspawn)
		##elif enemy_inattack_range == true && enemy_attack_cooldown == true && Input.is_action_just_pressed("attack_2") && player2in == true:
	elif enemy_inattack_range == true && Input.is_action_just_pressed("attack_2") && player2in == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)
		
		##Beetle attack sense
	elif enemy_inattack_range == true && Input.is_action_just_pressed("attack_2") && playerFriend == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)
	elif enemy_inattack_range == true && Input.is_action_just_pressed("attack_1") && playerFriend == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
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








func _on_animated_sprite_2d_animation_finished():
	if(animated_sprite.animation == "pain_%s" % [player_id]):
		queue_free()
	if(animated_sprite.animation == "Attack_%s" % [player_id]):
		$attackTitan.play()
		if $AnimatedSprite2D.flip_h == false && lock != 25 && player_chase == true:
			lock = 2
		else:
			lock = 1
		if $AnimatedSprite2D.flip_h == true && lock !=25 && player_chase == true:
			lock = 3
		else:
			lock = 1
		##var player_chase = true
		


func _on_animated_sprite_2d_animation_changed():
	if(animated_sprite.animation == "Attack_%s" % [player_id]):
		$attackTitan.play()


func _on_close_2_jump_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		detectJ = 2


func _on_close_2_jump_body_exited(body):
	if body.name == "Player" || body.name == "Player2":
		detectJ = 0
