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
./vis --2d --script=myvisualization.gd
```

See the documentation for gd script at the official [Godot Engine Documentation](https://docs.godotengine.org/).

While you can use it purely on the command line and with any text editor, it's most enjoyable to use with the full IDE experience with code error detection and autocompletion. To do that you should download the **Godot** game engine (no installation required), import a project, and use the `src/` directory from this `vis` repository as a project directory. After that, since you are not using the command line, you'll need to set the default command line arguments that `vis` expects, under `settings` menu, `project settings`, `General` tab, `Editor` category, and set `Main Run Args` to `--2d --script=readcsv.gd --file=animat_behavior.csv`.

To easily make an editor project for your gd file, use the following command the generate the project:

```bash
./vis --2d --script=myvisualization.gd --develop
```

The `vis` tool expects either `--2d` or `--3d`, then the `--script=` paramter should point to your visualization script. This particular included demo visualization script `readcsv.gd` instructs `vis` to expect another called `--file`, which is a csv file containing the data it will plot and animate.
