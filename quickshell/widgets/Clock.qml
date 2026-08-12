import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Io

PanelWindow {
    //basic ppt//
    anchors { top: true ; bottom: true ; left: true ; right: true }
    aboveWindows: false
    WlrLayershell.layer: WlrLayer.Bottom
     
    color: "transparent"
    
    //defining ppt//
    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    property real memUsage: 0
    
    //Logic//
    
    //cpu proc
    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var p = data.trim().split(/\s+/)
                var idle = parseInt(p[4]) + parseInt(p[5])
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                if (lastCpuTotal > 0) {
                    cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
                }
                lastCpuTotal = total
                lastCpuIdle = idle
            }
        }
        Component.onCompleted: running = true
    }

    //memory proc
    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                memUsage = (used / 1024 / 1024).toFixed(1)
            }
        }
        Component.onCompleted: running = true
    }
    
    //timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
        }
    }

    Text {
        id: clock
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 150
        text: Qt.formatDateTime(new Date(), "HH:mm")

        color: Qt.hsla(0, 0, 1, 1) 
        font {
            family: "SF Pro Display"
            pixelSize: 125
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 120
        text: Qt.formatDateTime(new Date(), "ddd, MMM dd")
        color: Qt.hsla(0, 0, 1, 1) 
        font {
            family: "SF Pro Display"
            pixelSize: 24
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 290
        text: "    CPU: " + cpuUsage + "%" + "    |    " + "    RAM: " + memUsage + " GiB"
        color: Qt.hsla(0, 0, 1, 0.5) 
        font {
            family: "SF Pro Display"
            pixelSize: 18
        }
    }
}
