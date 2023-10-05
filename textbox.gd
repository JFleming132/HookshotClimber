extends CanvasLayer
@onready var textbox_container = $MarginContainer
@onready var start_symbol = $MarginContainer/MarginContainer/HBoxContainer/StartSymbol
@onready var end_symbol = $MarginContainer/MarginContainer/HBoxContainer/EndSymbol
@onready var label = $MarginContainer/MarginContainer/HBoxContainer/MainText
const CHAR_READ_RATE = .05
enum State {
	READY,
	READING,
	FINISHED
}
var current_state = State.READY
var text_queue = []
# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state(State.READING)
	label.visible_ratio = 0
	var tween = get_tree().create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(label, "visible_ratio", 1, len(next_text) * CHAR_READ_RATE)
	show_textbox()
	
func _on_tween_finished():
	change_state(State.FINISHED)
	end_symbol.text = "V"
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("changing to ready")
		State.READING:
			print("changing to reading")
		State.FINISHED:
			print("changing to finished")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("interact"):
				for i in get_tree().get_processed_tweens().size():
					get_tree().get_processed_tweens()[0].kill()
				label.visible_ratio = 1.0
				end_symbol.text = "V"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("interact"):
				change_state(State.READY)
				hide_textbox()
