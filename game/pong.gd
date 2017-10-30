extends Node2D

enum {
	SIDE_LEFT=-1
	SIDE_RIGHT=1,
}

func _on_ball_out_of_screen(side):
	if side == SIDE_LEFT:
		Score.add_score(2) # player 2 wins
	elif side == SIDE_RIGHT:
		Score.add_score(1) # player 1 wins




	get_node("sfx").play('score')
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, 'pad', 'reset')
