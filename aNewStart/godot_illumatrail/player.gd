extends CharacterBody2D


var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 250
var player_alive = true

const SPEED = 230.0
const JUMP_VELOCITY = -385.0
@export var player_id = 1

##Lock variable
var lockJump = 1

##Health Display
@onready var label = $LabelHealth

##Name Tag
@onready var realname = $nameTagPlayers

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite2 : AnimatedSprite2D = $upSpark1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	##What displays the health
	label.text = "HP: " + str(health)
	enemy_attack()
	if health <= 0:
		player_alive = false
		health = 0
		print ("player has been killed")
		$death.play()
		queue_free()
		
	##Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		lockJump = 1


	##Ethers normal jump
	if Input.is_action_just_pressed("jump_%s" % [player_id]) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSfx.play()
	
	##Dawnspawns endless flaps
	if player_id == 2:
		realname.text = "Dawnspawn"
		if Input.is_action_just_pressed("jump_%s" % [player_id]):
			velocity.y = JUMP_VELOCITY
			
	##Set the name tags
	if player_id == 1:
		realname.text = "Ephtle"

	var direction = Input.get_axis("move_left_%s" % [player_id], "move_right_%s" % [player_id])


	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run_%s" % [player_id])
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		if lockJump == 1:
			$AnimatedSprite2D.play("jump_%s" % [player_id])
		elif lockJump == 2:
			$AnimatedSprite2D.play("idle_%s" % [player_id])
			velocity.x = move_toward(velocity.x, 0, SPEED / 2)

	##Animation lock logic
	if not is_on_floor() && lockJump != 0 && lockJump != 5:
		$AnimatedSprite2D.play("jump_%s" % [player_id])

	if is_on_floor() and lockJump != 0 and lockJump != 5:
		lockJump = 2
	
	##Attack animation
	if Input.is_action_just_pressed("attack_%s" % [player_id]):
		lockJump = 0 
		$AnimatedSprite2D.play("attack_%s" % [player_id])
	##Attack sounds
	if Input.is_action_just_pressed("attack_1"):
		$attPlayer.play()
	if Input.is_action_just_pressed("attack_2"):
		$attPlayer2.play()

	##the cross behind
	if(animated_sprite.animation == "attack_%s" % [player_id]):
		$upSpark1.play("upRoar_%s" % [player_id])
	else:
		$upSpark1.play("default")
	

	move_and_slide()


##Returns from the attack animation
func _on_animated_sprite_2d_animation_finished():
	if(animated_sprite.animation == "attack_%s" % [player_id]):
		lockJump = 2
		$AnimatedSprite2D.play("idle_%s" % [player_id])
	if(animated_sprite.animation == "hurt_%s" % [player_id]):
		lockJump = 2
		$AnimatedSprite2D.play("idle_%s" % [player_id])


##Damaged starter
func _on_player_hitbox_body_entered(body):
	if body.name == "entReal":
		enemy_inattack_range = true
		##Hurt animation
		lockJump = 5
		$AnimatedSprite2D.play("hurt_%s" % [player_id])
		
	if body.name == "gameEnder":
		health = 0
	
	if body.has_method("enemy"):
		enemy_inattack_range = true
		lockJump = 5
		$AnimatedSprite2D.play("hurt_%s" % [player_id])


##Damaged ender
func _on_player_hitbox_body_exited(body):
	if body.name == "entReal":
		enemy_inattack_range = false
	if body.has_method("enemy"):
		enemy_inattack_range = false


func enemy_attack():
	if enemy_inattack_range == true && enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$gotHurt.play()
		$attack_cooldown.start()
		print(health)

##So the enemy can detect the player
func player():
	pass

##Attack timer
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


##Gathering health with the lifebugs
func _on_add_health_body_entered(body):
	if body.name == "GemL":
		health = health + 3
	if body.has_method("life"):
		health = health + 3
