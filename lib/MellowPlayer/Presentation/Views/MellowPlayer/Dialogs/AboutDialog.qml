import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQml 2.2

import MellowPlayer 3.0
import ".."

Popup {
    id: popup

    padding: 20
    modal: true
    height: 490
    width: Math.max(labelBuildInfo.implicitWidth + 64, height)
    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    onVisibleChanged: if (!visible) btCredits.checked = false

    Material.accent: _theme.accent === "#ffc107" ? _theme.primary : _theme.accent

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Item {
            clip: true

            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 12

                Image {
                    source: "qrc:/MellowPlayer/Presentation/Resources/icons/mellowplayer.png"
                    fillMode: Image.PreserveAspectFit

                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredHeight: 128
                }

                Label {
                    font.bold: true
                    font.pixelSize: 32
                    text: "MellowPlayer"

                    Layout.alignment: Qt.AlignCenter
                }

                Label {
                    font.pixelSize: 16
                    text: Qt.application.version

                    Layout.alignment: Qt.AlignCenter
                }

                Label {
                    font.pixelSize: 16
                    text: qsTr("Cloud music integration for your desktop")

                    Layout.alignment: Qt.AlignCenter
                }

                Link {
                    name: qsTr('Website')
                    url: 'https://colinduquesnoy.github.io/MellowPlayer'

                    Layout.alignment: Qt.AlignCenter
                }

                Label {
                    text: qsTr("Copyright 2014-2017 Colin Duquesnoy")

                    Layout.alignment: Qt.AlignCenter
                }

                ColumnLayout {
                    spacing: 0

                    Layout.alignment: Qt.AlignCenter

                    Label {
                        font.pixelSize: 12
                        text: qsTr('This program comes with absolutely no warranty.')

                        Layout.alignment: Qt.AlignCenter
                    }

                    Label {
                        font.pixelSize: 12
                        onLinkActivated: Qt.openUrlExternally(link)
                        text: qsTr('See the <a href="https://www.gnu.org/licenses/old-licenses/lgpl-2.1">GNU Lesser General Public License</a>,')

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.NoButton
                            cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                        }

                        Layout.alignment: Qt.AlignCenter
                    }

                    Label {
                        font.pixelSize: 12
                        text: qsTr('version 2.1 or later for details.')

                        Layout.alignment: Qt.AlignCenter
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                Label {
                    id: labelBuildInfo
                    font.pixelSize: 10
                    font.italic: true
                    text: _app.buildInfo

                    Layout.alignment: Qt.AlignCenter
                    Layout.bottomMargin: 12
                }
            }

            Item {
                id: creditsPane

                readonly property int yPos: parent.height

                x: 6
                height: 148; width: parent.width - 12

                Pane {
                    anchors.fill: parent
                    anchors.topMargin: 2
                    anchors.leftMargin: 2
                    anchors.rightMargin: 2
                    anchors.bottomMargin: 0  // hide bottom elevation

                    padding: 16

                    Material.elevation: 2

                    ColumnLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        spacing: 9

                        RowLayout {
                            spacing: 9

                            ColumnLayout {
                                Label {
                                    text: qsTr("Created by")
                                }

                                Item { Layout.fillHeight: true }
                            }

                            ColumnLayout {
                                Link {
                                    name: '@ColinDuquesnoy'
                                    url: "https://github.com/ColinDuquesnoy"
                                }

                                Item { Layout.fillHeight: true }
                            }
                        }

                        RowLayout {
                            spacing: 9

                            ColumnLayout {
                                Label {
                                    text: qsTr("Artwork by")
                                }

                                Item { Layout.fillHeight: true }
                            }

                            ColumnLayout {
                                Link {
                                    name: '@CelineThiry'
                                    url: "https://github.com/CelineThiry"
                                }

                                Item { Layout.fillHeight: true }
                            }
                        }

                        RowLayout {
                            spacing: 9

                            ColumnLayout {
                                Label {
                                    text: qsTr("Contributors")
                                }

                                Item { Layout.fillHeight: true }
                            }

                            ColumnLayout {
                                Link {
                                    name: '@ConorIA'
                                    url: "https://github.com/ConorIA"
                                }

                                Link {
                                    name: '@ZeroDot1'
                                    url: "http://basic1.moy.su/"
                                }

                                Item { Layout.fillHeight: true }
                            }
                        }
                    }
                }

                state: btCredits.checked && popup.visible ? "open" : "closed"
                states: [
                    State {
                        name: "open"

                        PropertyChanges {
                            target: creditsPane

                            y: creditsPane.yPos - creditsPane.height
                            clip: false
                        }
                    },
                    State {
                        name: "closed"

                        PropertyChanges {
                            target: creditsPane

                            y: creditsPane.yPos
                            clip: true
                        }
                    }
                ]

                transitions: Transition {
                    from: "open"; to: "closed"
                    reversible: true

                    PropertyAnimation {
                        properties: "y"
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                id: btCredits
                checkable: true
                checked: false
                highlighted: checked
                flat: true
                text: qsTr("Credits")
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                flat: true
                highlighted: true
                onClicked: popup.close()
                text: qsTr("Close")
            }
        }
    }
}
