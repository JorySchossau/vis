# vis
2d and 3d cross-platform visualization tool, similar to Processing, based on Godot Engine.

### Releases

Download both the executable, and logic/assets file. Later, the assets file will be bundled into the executable.

##### Executable
(These are basically just the executables from the Godot Export Templates, minified, and hosted here for your convenience)
* [Windows](https://raw.githubusercontent.com/JorySchossau/vis/master/releases/exe/win/vis.exe)
* [MacOS](https://raw.githubusercontent.com/JorySchossau/vis/master/releases/exe/osx/vis) (safari will rename to `vis.dms`, so rename it back to `vis`, and set executable `chmod +x vis`)
* [Linux](https://raw.githubusercontent.com/JorySchossau/vis/master/releases/exe/lin/vis)

##### Logic/Assets (put in same place as executable)
* [vis.pck](https://raw.githubusercontent.com/JorySchossau/vis/master/releases/pck/vis.pck)

### Usage

Intended to be used on the command line.

```bash
./vis --2d --script=myvisualization.gd
```

See the documentation for gd script at the official [Godot Engine Documentation](https://docs.godotengine.org/).
