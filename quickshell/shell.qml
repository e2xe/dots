import QtQuick
import Quickshell

import "./dock"
import "./top_bar"
import "./widgets"


// load comps
ShellRoot {
    id: root

    property bool showClock: true
    property bool showDock: true

        Bar {
        showClock: root.showClock
        showDock: root.showDock
        onToggleClock: root.showClock = !root.showClock
        onToggleDock: root.showDock = !root.showDock
      }

    Dock { visible: root.showDock }

 
    Clock { visible: root.showClock }
}
