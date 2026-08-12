import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {

    property bool showClock: true
    property bool showDock: true

    readonly property url iconBase: Qt.resolvedUrl("./icons/")

    signal toggleClock()
    signal toggleDock()

    function openUrl(url) {
        Quickshell.execDetached(["helium", "--new-window", url])
    }

    function openTerm(cmd) {
        Quickshell.execDetached(["kitty", cmd])
    }

    anchors { top: true ; left: true ; right: true }
    height: 40
    color: Qt.hsla(0, 0, 0.035, 0.5)

    RowLayout {
        anchors.fill: parent
	anchors { topMargin: 5 ; bottomMargin: 5 ; leftMargin: 15 ; rightMargin: 15 }
	spacing: 15

        // --- toogles  ---
        RowLayout {
            spacing: 12

            Image {
                source: iconBase + "clock-icon.svg"
                Layout.preferredWidth: 17
                Layout.preferredHeight: 17
                sourceSize.width: 34
                sourceSize.height: 34
                smooth: true
                fillMode: Image.PreserveAspectFit
                opacity: showClock ? 0.65 : 0.2

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toggleClock()
                }
            }

            Image {
                source: iconBase + "dock-icon.svg"
                Layout.preferredWidth: 17
                Layout.preferredHeight: 17
                sourceSize.width: 34
                sourceSize.height: 34
                smooth: true
                fillMode: Image.PreserveAspectFit
                opacity: showDock ? 0.65 : 0.2

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toggleDock()
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 16
            color: Qt.hsla(0, 0, 1, 0.15)
        }

        // --- workspace module ---
        RowLayout {
            spacing: 15

            Repeater {
                model: 5

                Text {
                    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                    text: index + 1
                    color: isActive ? Qt.hsla(0, 0, 1, 0.5) : (ws ? Qt.hsla(0, 0, 1, 0.3) : Qt.hsla(0, 0, 1, 0.12))
                    font { family: "Iosevka Nerd Font"; pixelSize: 18 }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${index + 1} })`)
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        // --- shortcuts ---
        RowLayout {
            spacing: 16

            Repeater {
                model: [
                    { icon: "relay.svg", action: "app", value: "audiorelay" },
                    { icon: "network.svg", action: "term", value: "nmtui" },
                    { icon: "bluetooth.svg", action: "term", value: "bluetoothctl" }
                ]

                Image {
                    required property var modelData
                    source: iconBase + modelData.icon
                    Layout.preferredWidth: 17
                    Layout.preferredHeight: 17
                    sourceSize.width: 34
                    sourceSize.height: 34
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    opacity: launchArea.containsMouse ? 0.85 : 0.5

                    MouseArea {
                        id: launchArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.action === "url")
                                openUrl(modelData.value)
                            else if (modelData.action === "term")
                                openTerm(modelData.value)
                            else
                                Quickshell.execDetached([modelData.value])
                        }
                    }
                }
            }
        }

	}
}
