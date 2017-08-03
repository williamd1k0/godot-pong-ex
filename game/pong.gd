extends Node

signal p1_update(score)
signal p2_update(score)

func _ready():
	Score.connect('score_update', self, '_on_score_update')
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_select"):
		get_tree().set_pause(not get_tree().is_paused())

func _on_score_update(player, score):
	if player == 1:
		emit_signal('p1_update', str(score))
	else:
		emit_signal('p2_update', str(score))

func _on_ball_out_of_screen(side):
	if side == -1:
		Score.add_score(2)
	else:
		Score.add_score(1)
	get_node("SamplePlayer").play('score')
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, 'pad', 'reset')
