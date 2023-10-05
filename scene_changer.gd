extends Node

var current_scene = null
# Called when the node enters the scene tree for the first time.
func _ready():
	print("scene changer loaded")
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(scene, spawnID):
	print("callback shenanigan")
	call_deferred("_deferred_goto_scene", scene, spawnID)

func _deferred_goto_scene(scene, spawnID):
	print("attempting to load")
	var currentScore
	var currentHealth
	if current_scene.find_child("player", true) != null:
		currentScore = current_scene.find_child("player", true).score
		currentHealth = current_scene.find_child("player", true).health
	else:
		currentScore = 0
		currentHealth = 5
	current_scene.free()
	current_scene = ResourceLoader.load(scene).instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	var i = 0
	while spawnID != "skip" && i < current_scene.get_child_count():
		print("comparing names: ")
		print(spawnID)
		print(current_scene.get_children()[i].name)
		if (current_scene.get_children())[i].name == spawnID:
			print("Ding!")
			(current_scene.get_children())[i].add_child(load("res://player.tscn").instantiate())
			current_scene.get_children()[i].get_child(0).health = currentHealth
			current_scene.get_children()[i].get_child(0).score = currentScore
			break
		else:
			i += 1

func _process(_delta):
	pass
