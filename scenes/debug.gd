extends Label

@export var show_debug = true
var FPS = 0
var draw_calls = 0
var frame_time = 0
var VRAM = 0
var small_star_count = 0
var player
var data

func init(_player):
	player = _player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not show_debug:
		text = ""
		return
	else:
		FPS = Engine.get_frames_per_second()
		draw_calls = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME)
		frame_time = delta
		VRAM = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_VIDEO_MEM_USED) / 1024.0 / 1024.0
		small_star_count = get_tree().get_nodes_in_group("small_star").size()
		data = "FPS: " + str(FPS) + "\n" + \
		"Draw calls: " + str(draw_calls) + "\n" + \
		"Frame time: " + "%0.1f" % (frame_time * 1000) + " ms\n" + \
		"VRAM: " + "%0.1f" % VRAM + " MB\n" + \
		"small stars: " + str(small_star_count) + "\n"
		
		if Utils.is_valid_node(player):
			data += "Position: " + str(player.global_position) + "\n" + \
			"Rotation: " + str(player.rotation)
		
		text = data
