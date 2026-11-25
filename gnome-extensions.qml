import io.calamares.core
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Page {
    id: page
    readonly property var catalog: @catalog@
    readonly property var layouts: catalog.filter(x => x.group === "layout")
    property var selection: []
    property bool expanded: false

    function save(ids) {
        selection = ids
        Global.insert("stevo_gnome_extensions", JSON.stringify(ids))
    }
    function selectLayout(id) {
        save(selection.filter(key => !layouts.some(x => x.id === key)).concat([id]))
    }
    Component.onCompleted: {
        const key = "stevo_gnome_extensions"
        save(Global.contains(key) ? JSON.parse(Global.value(key)) :
             catalog.filter(x => x.default === true).map(x => x.id))
    }

    component Option: ColumnLayout {
        required property var modelData
        Layout.fillWidth: true
        spacing: 0
        CheckBox {
            text: modelData.label
            checked: page.selection.includes(modelData.id)
            onClicked: page.save(checked ? page.selection.concat([modelData.id]) :
                                 page.selection.filter(x => x !== modelData.id))
        }
        Label {
            Layout.leftMargin: Kirigami.Units.largeSpacing * 3
            Layout.fillWidth: true
            text: modelData.description
            wrapMode: Text.WordWrap
        }
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Kirigami.Units.smallSpacing
            Kirigami.Heading { text: "Desktop-Layout"; level: 2 }
            RowLayout {
                Repeater {
                    model: page.layouts
                    RadioButton {
                        required property var modelData
                        text: modelData.label
                        checked: page.selection.includes(modelData.id)
                        onClicked: page.selectLayout(modelData.id)
                    }
                }
            }
            Kirigami.Heading { text: "Erweiterungen für den ersten Login"; level: 2 }
            Repeater {
                model: page.catalog.filter(x => !x.group)
                delegate: Option {}
            }
            Button {
                text: page.expanded ? "Weitere Erweiterungen ausblenden" : "Weitere Erweiterungen anzeigen"
                onClicked: page.expanded = !page.expanded
            }
            Repeater {
                model: page.expanded ? page.catalog.filter(x => x.group === "more") : []
                delegate: Option {}
            }
        }
    }
}
