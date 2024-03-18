extends CharacterBody2D

var speed = 77


var player_chase = false
var player = null

var lock = 1
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var player_far = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
##For the player
var playerFound = false

##Health stuff again
@onready var label = $LabelHealth
var health = 100
var player_alive = true

var enemy_inattack_range = false
var enemy_attack_cooldown = true



func _physics_process(delta):
	label.text = "HP: " + str(health)
	enemy_attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print ("Beetle has been killed")
		lock = 10

	if not is_on_floor():
		velocity.y += gravity * delta
		

	if player_chase && lock != 5 && lock != 10:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")

		if(player.position.x - position.x) < 0: 
			$AnimatedSprite2D.flip_h = true
			$upSpark1.flip_h = true
		else: 
			$AnimatedSprite2D.flip_h = false
			$upSpark1.flip_h = false
	elif lock == 1:
		$AnimatedSprite2D.play("idle")
		
	if Input.is_action_just_pressed("attack_1") || Input.is_action_just_pressed("attack_2"):
		lock = 5
		$AnimatedSprite2D.play("attack")
		$rupSpark2.play("sparkB")
		$upSpark1.play("upRoar_b")
	##Sound
	if Input.is_action_just_pressed("attack_1") || Input.is_action_just_pressed("attack_2"):
		if playerFound == true:
			$AttackSfx.play()
	##Death animation
	if health == 0:
		$AnimatedSprite2D.play("death")

##Player detector
func _on_detection_area_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		player = body
		player_chase = true
	playerFound = true
	
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	

##So the enemy can detect the ally
func player_ally():
	pass


##Returns the attack animation
func _on_animated_sprite_2d_animation_finished():
	if(animated_sprite.animation == "attack"):
		lock = 1
		$AnimatedSprite2D.play("idle")
		$rupSpark2.play("default")
		$upSpark1.play("default")
	
	
	##Deletes the beetle 
	if(animated_sprite.animation == "death"):
		$death.play()
		queue_free()


func _on_player_hitbox_body_entered(body):
	if body.name == "entReal":
		enemy_inattack_range = true
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
	if body.name == "entReal":
		enemy_inattack_range = false
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range == true && enemy_attack_cooldown == true:
		health = health - 25
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Beetle got splinters. HP: ")
		print(health)



func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true




