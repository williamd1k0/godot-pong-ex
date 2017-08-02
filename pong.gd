extends Node2D

enum {
	DIR_UP=-1,
	DIR_DOWN=1,
	DIR_LEFT=-1,
	DIR_RIGHT=1
}

signal game_over(winner)

# Member variables
export(int) var INITIAL_BALL_SPEED = 80

onready var ball_speed = INITIAL_BALL_SPEED
onready var ball = get_node("ball")

var screen_size = OS.get_window_size()
var pad_size

# Default ball direction
var direction = Vector2(-1, 0)

func _ready():
	connect("game_over", self, '_on_game_over')
	# TODO: use groups
	pad_size = get_tree().get_nodes_in_group('pad')[0].get_item_rect().size
	set_process(true)

func _process(delta):
	# Get ball position and pad rectangles
	var ball_pos = ball.get_pos()
	var left_rect = Rect2(get_node("left").get_pos() - pad_size*0.5, pad_size)
	var right_rect = Rect2(get_node("right").get_pos() - pad_size*0.5, pad_size)
	
	# Integrate new ball postion
	ball_pos += direction*ball_speed*delta
	
	# Flip when touching roof or floor
	var dir_y = sign(direction.y)
	if ((ball_pos.y < 0 and dir_y == DIR_UP)
		or (ball_pos.y > screen_size.y and dir_y == DIR_DOWN)):
		direction.y = -direction.y
	
	# Flip, change direction and increase speed when touching pads
	var dir_x = sign(direction.x)
	if ((left_rect.has_point(ball_pos) and dir_x == DIR_LEFT)
		or (right_rect.has_point(ball_pos) and dir_x == DIR_RIGHT)):
		direction.x = -direction.x
		ball_speed *= 1.1
		direction.y = randf()*2.0 - 1
		direction = direction.normalized()
	
	# Check gameover
	if ball_pos.x < 0:
		emit_signal('game_over', 2)
	elif ball_pos.x > screen_size.x:
		emit_signal('game_over', 1)
	else:
		ball.set_pos(ball_pos)

func _on_game_over(winner):
	ball_speed = INITIAL_BALL_SPEED
	direction = Vector2(-1, 0)
	ball.set_pos(screen_size*0.5)
	Score.add_score(winner)
	get_tree().call_group(SceneTree.GROUP_CALL_DEFAULT, 'pad', 'reset')
