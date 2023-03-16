# vis
2d and 3d cross-platform visualization tool, similar to Processing, based on Godot Engine. Unliked Processing, Vis handles rendering for you, while still giving you performant control, so you don't have to "paint every frame" and you are not limited to immediate-style GUI.

### Releases

Download both the executable, and logic/assets file. Later, the assets file will be bundled into the executable.

##### Executable
(These are basically just the executables from the Godot Export Templates, minified, and hosted here for your convenience)
* [Windows](https://raw.githubusercontent.com/JorySchossau/vis/master/releases/exe/win/vis.zip)
* [MacOS](https://raw.githubusercontent.com/JorySchossau/vis/master/releases/exe/osx/vis.zip) (safari will rename to `vis.dms`, so rename it back to `vis`, and set executable `chmod +x vis`)
* [Linux](https://raw.githubusercontent.com/JorySchossau/vis/master/releases/exe/lin/vis.zip)

### Usage

Intended to be used on the command line.

```bash
# example 1
cd examples/2d-bouncing
# (download vis tool to here or put it on your path)
./vis --2d --script=simple.gd
```

Particular visualization scripts may themselves require additional arguments, such as the 2d-foraging example:

```bash
# example 2
cd examples/2d-foraging
# (download vis tool to here or put it on your path)
unzip csvdata.zip
./vis --2d --script=readcsv.gd --file=csvdata.csv
```

See the documentation for gd script at the official [Godot Engine Documentation](https://docs.godotengine.org/).

While you can use it purely on the command line and with any text editor, it's most enjoyable to develop new script code with the full IDE experience with error detection, autocompletion, and documentation. To do that you should download the **Godot** game engine (no installation required), generate a project for a new `.gd` file, and open that project using the editor.

To easily make an editor project for your gd file giving you code completion and documentation, use the following command to generate the project, then open the project using the [full official godot editor](https://godotengine.org/download):

```bash
./vis --2d --script=myvisualization.gd --develop
```

### Options

* `--2d` expects a 2D visualization script
* `--3d` expects a 3D visualization script
* `--script=<filename>` specify a gd script to run
* `--develop` generate a project for editing that script
* `--write-movie <filename.avi>` run the visualization, and create a movie (godot v4 feature)
* `--fixed-fps 30` limit the movie-writing to a certain FPS (godot v4 feature)
