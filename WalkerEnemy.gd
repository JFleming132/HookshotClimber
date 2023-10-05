extends CharacterBody2D


const SPEED = 450
@export var startDirection : int
@export var detectCliffs : bool
var doPhysics = true
var currentDirection
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prevFramePosition

func _ready():
	currentDirection = startDirection
	$AnimationPlayer.play("walk")

func _physics_process(delta):
	if doPhysics:
		if position == prevFramePosition:
			currentDirection = currentDirection * -1
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		velocity.x = currentDirection * SPEED * delta
		prevFramePosition = position
		move_and_slide()
	

func _on_hitbox_body_entered(body):
	print("hitbox body entered")
	doPhysics = false
	$AnimationPlayer.play("die")
	if body.has_method("jump"):
		body.jump()
	set_collision_layer_value(2, 0)
	set_collision_mask_value(4, 0)
	$Hitbox.set_collision_layer_value(2, 0)
	$Hitbox.set_collision_mask_value(4,0)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()


func _on_hurtbox_body_entered(body):
	print("hurtbox body entered")
	body.hurt()
