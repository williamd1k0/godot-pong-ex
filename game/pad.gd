extends Sprite

export(int, "None", "Player 1", "Player 2") var player = 1
const PAD_SPEED = 200
var screen_size = OS.get_window_size()

func _ready():
	reset()
	set_process(true)

func _process(delta):
	# Move pad
	var pad_pos = get_pos()
	
	if Input.is_action_pressed("move_up_%s" % player):
		pad_pos.y -= PAD_SPEED*delta
	elif Input.is_action_pressed("move_down_%s" % player):
		pad_pos.y += PAD_SPEED*delta
	
	# Limit position
	pad_pos.y = clamp(pad_pos.y, 0, screen_size.y)
	set_pos(pad_pos)

func reset():
	set_pos(Vector2(get_pos().x, screen_size.y/2))
