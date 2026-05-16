import QtQuick 2.12
import calamares.slideshow 1.0

Presentation {
    id: presentation

    // Hyprose color palette
    property color rosePink: "#ff6b9d"
    property color darkBg: "#0f0f1a"
    property color accentBg: "#1a1a2e"
    property color textColor: "#e8e8e8"

    Rectangle {
        anchors.fill: parent
        color: darkBg

        // Animated gradient background
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0f0f1a" }
                GradientStop { position: 0.5; color: "#1a1a2e" }
                GradientStop { position: 1.0; color: "#16213e" }
            }
        }

        // Rose accent glow
        Rectangle {
            width: 300
            height: 300
            radius: 150
            anchors.centerIn: parent
            color: rosePink
            opacity: 0.1

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.2; duration: 2000 }
                NumberAnimation { to: 0.1; duration: 2000 }
            }
        }

        // Content container
        Column {
            anchors.centerIn: parent
            spacing: 20

            // Logo text
            Text {
                text: "🌹"
                font.pixelSize: 64
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Hyprose"
                font.pixelSize: 48
                font.bold: true
                color: rosePink
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "JetBrains Mono"
            }

            Text {
                text: "Installing your Hyprland rice..."
                font.pixelSize: 18
                color: textColor
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0.8
            }

            // Progress indicator
            Rectangle {
                width: 200
                height: 4
                radius: 2
                color: accentBg
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: parent.width * (presentation.slideNumber / presentation.slideCount)
                    height: parent.height
                    radius: 2
                    color: rosePink

                    Behavior on width {
                        NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
                    }
                }
            }

            // Slide content
            Text {
                text: {
                    var slides = [
                        "Setting up base system...",
                        "Installing Hyprland compositor...",
                        "Configuring Quickshell widgets...",
                        "Applying Material You theming...",
                        "Setting up AI sidebar...",
                        "Installing end-4 dotfiles...",
                        "Configuring GPU drivers...",
                        "Almost there..."
                    ]
                    return slides[presentation.slideNumber % slides.length]
                }
                font.pixelSize: 14
                color: textColor
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: 0.6
            }
        }

        // Floating particles effect
        Repeater {
            model: 20
            Rectangle {
                width: Math.random() * 4 + 2
                height: width
                radius: width / 2
                color: rosePink
                opacity: Math.random() * 0.3 + 0.1
                x: Math.random() * parent.width
                y: Math.random() * parent.height

                SequentialAnimation on y {
                    loops: Animation.Infinite
                    NumberAnimation { to: -20; duration: Math.random() * 5000 + 5000 }
                    NumberAnimation { to: parent.height + 20; duration: 0 }
                }
            }
        }
    }

    // Auto-advance slides
    Timer {
        interval: 4000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }
}
