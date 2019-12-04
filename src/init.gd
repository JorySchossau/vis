extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().quit()
	
	var args = Array(OS.get_cmdline_args())
	if not args.has("--2d") and not args.has("--3d"):
		print("\nError: specify --2d or --3d mode\n\n");
		get_tree().quit()
	if args.has("--2d"):
		get_tree().change_scene("res://2d-scene.tscn")
	elif args.has("--3d"):
		get_tree().change_scene("res://3d-scene.tscn")
