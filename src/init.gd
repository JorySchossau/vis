extends Node2D

func _develop_with_source(filename: String):
	if not FileAccess.file_exists(filename):
		print("Error, no script file: "+filename)
		await get_tree().create_timer(0.1).timeout
		get_tree().quit()
	var basename = filename.get_basename().split('/')[-1]
	var source_file = FileAccess.open(filename, FileAccess.READ)
	var basedir = source_file.get_path_absolute().get_base_dir()
	if basedir == "":
		basedir = "."
	source_file.close()
	var projectname = basename+'_project'
	# extract template
	var contents := FileAccess.get_file_as_bytes("res://vis_template.res")
	var output = FileAccess.open(basedir+"/vis_template.zip",FileAccess.WRITE)
	output.store_buffer(contents)
	output.close()
	OS.execute("tar", ["-xf", basedir+"/vis_template.zip", "-C", basedir])
	# remove temporary zip file
	DirAccess.remove_absolute(basedir+'/vis_template.zip')
	# rename extracted to project name
	if not DirAccess.dir_exists_absolute(basedir+'/'+projectname):
		DirAccess.rename_absolute(basedir+'/vis_template',basedir+'/'+projectname)
	else:
		print("project dir already exists")
	# copy script into project
	DirAccess.copy_absolute(filename, basedir+'/'+projectname+'/'+basename+'.gd')
	# tweak editor run settings to run the script by default
	var config = ConfigFile.new()
	config.load(basedir+'/'+projectname+'/project.godot')
	var type: String
	if VIS.args.has("--2d"): type = "--2d"
	elif VIS.args.has("--3d"): type = "--3d"
	config.set_value("editor","run/main_run_args","--script=%s.gd %s" % [basename, type])
	config.save(basedir+'/'+projectname+'/project.godot')
	print("")
	print("Note: Make sure to change Run Args if necessary.\nProject, Project Settings. Toggle Advanced Settings. Editor > Run > Main Run Args")
	print("")

# Called when the node enters the scene tree for the first time.
func _ready():
	var args = OS.get_cmdline_args()
	if Engine.is_editor_hint():
		args.append("--develop")
	for arg in args:
		var split = arg.split('=')
		if split.size() == 1: # if flag
			VIS.args[split[0]] = true
		else: # if parameter
			VIS.args[split[0]] = split[1]
	if len(args) > 0:
		#if '=' in args[0] and args[0].begins_with("--script"):
		if VIS.args.has("--develop") and VIS.args.has("--script"):
			print("developing")
			var filename = VIS.args["--script"]
			_develop_with_source(filename)
			if Engine.is_editor_hint():
				await get_tree().create_timer(0.1).timeout
			get_tree().quit()

	#var args = Array(OS.get_cmdline_args())
	if VIS.args.has("--2d") == VIS.args.has("--3d"):
		print("\nError: specify only --2d or --3d mode\n\n");
		get_tree().quit()
	if VIS.args.has("--2d"):
		get_tree().change_scene_to_file("res://2d-scene.tscn")
	elif VIS.args.has("--3d"):
		get_tree().change_scene_to_file("res://3d-scene.tscn")
