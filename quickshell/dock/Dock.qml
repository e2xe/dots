import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    anchors { bottom: true ; left: true ; right: true }
    margins { bottom: 8 }
    height: 64
    color: "transparent"
    aboveWindows: false
    WlrLayershell.layer: WlrLayer.Bottom

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        height: 58

        implicitWidth: dockContent.implicitWidth + 24

        radius: 18
        color: Qt.hsla(0, 0, 0.1, 0.45)
        border.color: Qt.hsla(0, 0, 1, 0.27)
        border.width: 2

        RowLayout {
            id: dockContent
            anchors.fill: parent
            anchors.margins: 6
            spacing: 8

            Repeater {
                model: [
                    { icon: "helium", app: "helium" },
                    { icon: "kitty", app: "kitty" },
                    { icon: "anki", app: "anki" },
		    { icon: "pcmanfm-qt", app: "pcmanfm-qt" }
	    	]

                Item {
                    required property var modelData

                    Layout.preferredWidth: 46
                    Layout.preferredHeight: 46

                    Image {
                        anchors.centerIn: parent
                        width: 36
                        height: 36
                        sourceSize.width: 36
                        sourceSize.height: 36
                        smooth: true
                        source: "file:///usr/share/icons/Papirus-Dark/48x48/apps/" + modelData.icon + ".svg"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached([modelData.app])
                    }
                }
            }
        }
    }
}
