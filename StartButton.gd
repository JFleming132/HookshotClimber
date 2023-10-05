extends Button

@onready var animationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("not_pressed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_button_down():
	animationPlayer.play("pressed")
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	SceneChanger.goto_scene("res://hub1.tscn", "PlayerRespawnFromLevel")
