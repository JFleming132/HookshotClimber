extends CharacterBody2D

const NULL_TILE = Vector2i(-1, -1)
const SPEED = 100.0
const JUMP_VELOCITY = -250.0
@export_range(0.0, 1.0) var FRICTION = .1
@export_range(0.0, 1.0) var ACCELERATION = .1
const HOOK_SPEED = 275
@onready var animationPlayer = $AnimationPlayer
var coyoteTime = 0
var speed = 0
var jumpTime = 0
var canShoot = 15
var facing = "right"
var respawnScene = null
var health = 5
var score = 0
@onready var state = "walking"
var Hook = load("res://Hook.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var iframes = 0
var doHurt = false



func _ready():
	respawnScene = get_parent().newRespawnScene

func _physics_process(delta):
	if iframes > 0:
		iframes -= 1
	if health == 0:
		die()
	if state == "walking":
		# Add the gravity and handle coyote time
		if not is_on_floor():
			velocity.y += gravity * delta
			coyoteTime -= 1
		if is_on_floor():
			coyoteTime = 8

		# Handle Jump. Jumping happens as long as jump is pressed 3 frames before hitting the ground and
		# the player has some coyote time remaining
		if Input.is_action_just_pressed("jump"):
			jumpTime = 8
		
		if (jumpTime > 0) and (coyoteTime > 0):
			jump();
			
		if (jumpTime > 0):
			jumpTime -= 1;
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("moveLeft", "moveRight")
		if direction:
			velocity.x = lerp(velocity.x, direction * SPEED, ACCELERATION)
		else:
			velocity.x = lerp(velocity.x, 0.0, FRICTION)
		
		if (canShoot < 30):
			canShoot += 1
		if Input.is_action_just_pressed("shoot") && canShoot == 30:
			shoot()
			canShoot = 0
		#handle sprite animation
		if is_on_floor():
			if (direction != 0):
				animationPlayer.play("walk")
			if (direction == 0):
				animationPlayer.play("idle")
		else:
			if (velocity.y > 0):
				animationPlayer.play("fall")
			else:
				animationPlayer.play("jump")
		if velocity.x < 0 && (canShoot == 30):
			$Sprite2D.flip_h = true
			if facing == "right":
				facing = "left"
				$hookshot.position.x *= -1
				$hookshot.scale.x = -1
		if velocity.x > 0 && (canShoot == 30):
			$Sprite2D.flip_h = false
			if facing == "left":
				facing = "right"
				$hookshot.position.x *= -1
				$hookshot.scale.x = 1
		speed = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
		$ProjectedMovement.position = velocity * delta
		move_and_slide()
	else:
		velocity.y = 0
		velocity.x = HOOK_SPEED
		if facing == "left":
			velocity.x *= -1
		if Input.is_action_just_pressed("shoot"):
			state = "walking"
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			state = "walking"
			coyoteTime = 0
			jumpTime = 0
		speed = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2))
		$ProjectedMovement.position = velocity * delta
		move_and_slide()
		
func _on_projected_movement_body_entered(body):
	print("body entered")
	if "breaking" in body and speed > 150:
		body.breaking = true
		
func shoot():
	var h = Hook.instantiate()
	add_child(h)
	h.transform = $hookshot.transform
	
func die():
	score = 0
	health = 5
	SceneChanger.goto_scene(respawnScene, "PlayerRespawnFromLevel")

func hurt(): #This function needs polished to prevent player from turning around
	#while hurt, and also to make them flash or recolor
	health -= 1
	iframes = 15
	canShoot = 15
	if facing == "right":
		velocity.x = -500
		velocity.y = 100
	else:
		velocity.x = 500
		velocity.y = 100

func jump():
	velocity.y = JUMP_VELOCITY
	coyoteTime = 0
	jumpTime = 0

#need to write and implement a function to cause player to jump automatically
#off of defeated enemies
