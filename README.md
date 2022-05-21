# GodotVCamera
"Virtual Camera" addon inspired by Cinemachine for Unity

Create VCameras (green icon) and set their priorities to automatically transition smoothly between them with the highest priority camera being used by VCameraBrains (red icon).

Add Effects (blue icon) to your scene hierarchy to easily add screenshake, uniform movement, following, and look-at behavior to cameras (or other objects). See the included example scene for an idea of how to make use of these. 

![Example Scene](https://raw.githubusercontent.com/BtheDestroyer/GodotVCamera/main/addons/virtualcamera/Screenshots/ExampleScene.png)

A major difference between this addon and Cinemachine is that rather thanhaving a single "VCamera" node that does everything, I've decided to split up functionality across many different Nodes which all serve one purpose rather than cramming everything into a single "VCamera" Node. These Nodes can be parented to each other in the scene heirarchy to compose more dynamic behavior.

## Features

### VCamera Priority + Automatic Transitions

Two static cameras with the second having its priority raised and lowered.

The first has a "Linear" transition mode while the second is "Smooth Step".

![Transitions](https://raw.githubusercontent.com/BtheDestroyer/GodotVCamera/main/addons/virtualcamera/Screenshots/Transitions.gif)

### Screenshake

A "Shake" Node with its rotation strength set to (10, 10, 0).

![Screenshake](https://raw.githubusercontent.com/BtheDestroyer/GodotVCamera/main/addons/virtualcamera/Screenshots/Screenshake.gif)

### Character Follow

A "Follower" Node is being used to constantly interpolate towards the character.

A "LookAt" Node is being used to always look in the direction the character is moving.

Another "LookAt" Node with a positional offset places the camera behind and above the character, but always looking just above it.

![Character Follow](https://raw.githubusercontent.com/BtheDestroyer/GodotVCamera/main/addons/virtualcamera/Screenshots/Follwer.gif)
