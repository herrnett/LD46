extends AudioStreamPlayer

onready var tween = get_node("Tween")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

func fade_out():
	# tween music volume down to 0
	tween.interpolate_property(self, "volume_db", 0, -80, 5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	self.playing = false

func fade_in():
	self.playing = true
	tween.interpolate_property(self, "volume_db", -80, 0, 6, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
