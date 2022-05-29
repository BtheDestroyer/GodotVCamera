# GodotVCamera

"Virtual Camera" addon inspired by Cinemachine for Unity

[![Usage badge](https://pluginstats.brycedixon.dev/badge/count?project=VCamera)](#privacy-notice)

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

A "Follow" Node is being used to constantly interpolate towards the character.

A "LookAt" Node is being used to always look in the direction the character is moving.

Another "LookAt" Node with a positional offset places the camera behind and above the character, but always looking just above it.

![Character Follow](https://raw.githubusercontent.com/BtheDestroyer/GodotVCamera/main/addons/virtualcamera/Screenshots/Follwer.gif)

### 3rd Person Camera

A "Follow" Node is being used to constantly track the character's position.

An "Orbiter" Node is being used to allow the player to look around with the mouse or right stick.

A "LookAt" Node with a positional offset always looks just above the character.

![3rd Person Camera](https://raw.githubusercontent.com/BtheDestroyer/GodotVCamera/main/addons/virtualcamera/Screenshots/Orbiter.gif)

### Look At Group

A "LookAtGroup" Node is being used to look at the center of multiple objects (the two thin pillars and the player).

![Look At Group](https://raw.githubusercontent.com/BtheDestroyer/GodotVCamera/main/addons/virtualcamera/Screenshots/LookAtGroup.gif)

## Privacy Notice

As of version 1.1, this addon has a feature where it sends an HTTP POST request to a webserver which includes the SHA256 hash of the project name it's being used in, which may be considered identifying information. The purpose of this data collection is purely to track the number of projects the addon is used in.

By enabling this plugin without modification, you agree to this data collection. If you would like to disable this data collection, you may remove the `_enter_tree` function in `plugin.gd`.
