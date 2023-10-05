extends Area2D

var speed = 500
var bulletTime = 30
var state = "firing"
@onready var dir = get_node("../hookshot").scale.x
@onready var player = get_node("..")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if state == "firing":
		position.x += speed * delta * dir
		bulletTime -= 1
	if state == "hooked":
		position.x += player.velocity.x * -1 * delta
		if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("shoot")):
			queue_free()
	if bulletTime < 0:
		queue_free()
		
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var body_coords = body.get_coords_for_body_rid(body_rid)
		var tile_data = body.get_cell_tile_data(0, body_coords)
		var hookable = tile_data.get_custom_data_by_layer_id(0)
		print(hookable)
		if hookable:
			player.state = "hooking"
			state = "hooked"
			
		else:
			player.canShoot = 30
			queue_free()

