extends Sprite

signal out_of_screen(side)

enum {
	DIR_UP=-1,
	DIR_DOWN=1,
	DIR_LEFT=-1,
	DIR_RIGHT=1
}

# Member variables
export(int) var INITIAL_BALL_SPEED = 80

onready var ball_speed = INITIAL_BALL_SPEED
onready var pads = get_tree().get_nodes_in_group('pad')

var screen_size = OS.get_window_size()
var pad_size

# Default ball direction
var direction = Vector2(sign(randf()*2.0 - 1), 0)

func _ready():
	connect("out_of_screen", self, '_on_out_of_screen')
	pad_size = pads[0].get_item_rect().size
	set_process(true)

func _process(delta):
	# Get ball position
	var ball_pos = get_pos()

	# Integrate new ball postion
	ball_pos += direction*ball_speed*delta
	
	# Flip when touching roof or floor
	var dir_y = sign(direction.y)
	if ((ball_pos.y < 0 and dir_y == DIR_UP)
		or (ball_pos.y > screen_size.y and dir_y == DIR_DOWN)):
		direction.y = -direction.y
		get_node("SamplePlayer2D").play('tap')
	
	# Flip, change direction and increase speed when touching pads
	var dir_x = sign(direction.x)
	for pad in pads:
		var pad_rect = Rect2(pad.get_pos() - pad_size*0.5, pad_size)
		if pad_rect.has_point(ball_pos) and dir_x == sign(pad.get_pos().x - get_pos().x):
			direction.x = -direction.x
			ball_speed *= 1.1
			direction.y = randf()*2.0 - 1
			direction = direction.normalized()
			get_node("SamplePlayer2D").play('tap')
	
	# Check gameover
	if ball_pos.x < 0:
		emit_signal('out_of_screen', DIR_LEFT)
	elif ball_pos.x > screen_size.x:
		emit_signal('out_of_screen', DIR_RIGHT)
	else:
		set_pos(ball_pos)

func _on_out_of_screen(side):
	ball_speed = INITIAL_BALL_SPEED
	direction = Vector2(sign(randf()*2.0 - 1), 0)
	set_pos(screen_size*0.5)
