extends Node

var hook:Node2D

var timer = Timer.new()
var fpstxt = Label.new()

func fpsUpdate():
	fpstxt.text = "fps: " + str(Engine.get_frames_per_second())

func _input(event):
	if event.is_action("ui_quit"):
		cleanAndQuit()
	if Input.is_key_pressed(KEY_BACKSLASH):
		if fpstxt.visible:
			timer.stop()
			fpstxt.visible = false
		else:
			timer.start()
			fpstxt.visible = true

func cleanAndQuit():
	hook.free()
	get_tree().quit()

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	hook = Node2D.new()
	var script = GDScript.new()
	var file: FileAccess
	var args = OS.get_cmdline_args()
#	for arg in args:
#		var split = arg.split('=')
#		if split.size() == 1: # if flag
#			VIS.args[split[0]] = true
#		else: # if parameter
#			VIS.args[split[0]] = split[1]
	if len(args) > 0:
		#if '=' in args[0] and args[0].begins_with("--script"):
		if VIS.args.has("--script"):
			#var filename = args[0].split('=')[1]
			var filename = VIS.args["--script"]
			file = FileAccess.open(filename, FileAccess.ModeFlags.READ)
			if file == null:
				print("Error opening file:"+filename)
				return
			script.set_source_code(file.get_as_text())
			file.close()
			script.reload()
			hook.set_script(script)
			add_child(hook)
			## add fps timer
			self.add_child(timer)
			timer.connect("timeout",Callable(self,"fpsUpdate"))
			timer.wait_time = 1.0
			timer.one_shot = false
			self.add_child(fpstxt)
			fpstxt.visible = false
			fpstxt.text = "fps: "
			return
	hook.call_deferred("free")
	script.call_deferred("free")
	file.call_deferred("free")
	print("\nError: No script provided. Please call vis like below.")
	print("example: ./vis --script=myfile.gd")
	print("")
	get_tree().quit()
	
