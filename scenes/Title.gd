extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start_game
var running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func startgame():
	if !running:
		if Input.is_action_just_pressed("ui_accept"):
			running = true
			var tween = get_node("Tween")
			tween.interpolate_property(self, "modulate", modulate, Color(255, 255, 255, 0), 2, Tween.TRANS_QUINT, Tween.EASE_OUT)
			tween.start()
			yield(tween, "tween_completed")
			visible = false
			emit_signal("start_game")
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
