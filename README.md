# Touch Tracker
An iOS application that lets a user draw lines in different colors by dragging finger(s) across the screen.

<img src="https://media.giphy.com/media/xT0xeLNdvyCGDKutVK/giphy.gif">

## Requirements
  * An Intel-based Mac
  * [iOS 7 SDK or later](https://developer.apple.com/download/)
  * [Xcode 5 or later](https://developer.apple.com/xcode/)
  
   **Note:** A code signing key from Apple is required to deploy apps to a device. Without a developer key, the app
             can only be installed on the iPhone/iPad Simulator.
  
## Instructions
**How can I run this project?**

1. Open your terminal and clone the repository:
   ```
   $ git clone https://github.com/cramaechi/touch-tracker.git
   ```
   or [download as ZIP](https://github.com/cramaechi/touch-tracker/archive/master.zip).
  
2. Navigate to the project's directory:
   ```
   $ cd touch-tracker
   ```
   
3. Double-click on the TouchTracker.xcodeproj file.
   
4. Find the current scheme pop-up menu on the Xcode toolbar and select the  **iPhone 5s** scheme.
   
5. Finally, click on the ► button at the top-left corner of the Xcode toolbar to run the app.

## Usage
* To **draw** a line, hold down the mouse button while moving around the simulator screen until you have finished.
  
  To draw a line in a **_different color_**, hold down the option key + shift key and swipe your mouse cursor up to display<br />
  the color panel. Once the color panel is shown, click on any of the six colors, hold down the option key + shift key<br />
  and then swipe your mouse cursor down to hide the color panel. Once the color panel is hidden, you can then begin
  drawing lines in the new color you selected.
  
  To draw **_multiple lines_** simultaneously, hold down the option key as you drag your mouse cursor around the screen.
  
* To **move** a line, place your mouse cursor over the selected line, hold down the mouse button and wait for
  the line to turn green to begin moving the line around.
  
* To **delete** a line, click on the selected line, wait for a menu to appear with the "delete" option and then select it.

* To **delete _all_** lines, just double-click on on the screen.
