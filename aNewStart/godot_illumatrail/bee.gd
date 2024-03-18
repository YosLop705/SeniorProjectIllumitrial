extends CharacterBody2D

var speed = 75


var player_chase = false
var player = null

var lock = 1
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var player_far = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

##Health stuff again
@onready var label = $LabelHealth
var health = 15
var player_alive = true

var enemy_inattack_range = false
var enemy_attack_cooldown = true



func _physics_process(delta):
	label.text = "HP: " + str(health)

	if health <= 0:
		player_alive = false
		health = 0
		print ("Beetle has been killed")
		lock = 10

	if not is_on_floor():
		velocity.y += gravity * delta
		

	if player_chase && lock != 5 && lock != 10 && lock != 500:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")

		if(player.position.x - position.x) < 0: 
			$AnimatedSprite2D.flip_h = false
		else: 
			$AnimatedSprite2D.flip_h = true
	elif lock == 1:
		$AnimatedSprite2D.play("idle")
		


	##Death animation
	if health == 0:
		$AnimatedSprite2D.play("death")

##Player detector
func _on_detection_area_body_entered(body):
	if body.name == "Player" || body.name == "Player2":
		player = body
		player_chase = true
	
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	

##So the enemy can detect the ally
func player_ally():
	pass

##So the enemy can detect the ally
func stung():
	pass

##Returns the attack animation
func _on_animated_sprite_2d_animation_finished():
	##Deletes the beetle 
	if(animated_sprite.animation == "death"):
		queue_free()

func _on_attack_area_body_entered(body):
	if body.has_method("enemy"):
		$beeAtt.play()
		lock = 500
		$AnimatedSprite2D.play("death")



