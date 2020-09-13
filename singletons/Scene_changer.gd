extends Node2D

onready var animation_player = $AnimationPlayer
onready var colorrect = $ColorRect


func change_scene(path, delay = 0.5, fadeoutfirst = true):
	yield(get_tree().create_timer(delay), "timeout")
	if fadeoutfirst:
		animation_player.play("fade")
		yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("fade")
