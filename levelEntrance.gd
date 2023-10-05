extends Area2D

var actionable = false
@export var scene_to_load: String
@export var spawn_node_name: String
@export var respawn_scene_name: String
# Called when the node enters the scene tree for the first time.
func _ready():
	if scene_to_load == null:
		print("null scene")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if actionable and Input.is_action_just_pressed("interact"):
		print("pressed a button")
		SceneChanger.goto_scene(scene_to_load, spawn_node_name)

func _on_body_entered(body):
	if body.name == "Player":
		actionable = true
		print("actionable")

func _on_body_exited(body):
	if body.name == "Player":
		actionable = false
		print("not actionable")
