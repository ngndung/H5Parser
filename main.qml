import QtQuick 2.12
import QtQuick.Window 2.12
import GenerateData 1.0
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    MessageDialog {
        id: messageDialog
        title: "Infomation"
        text: "Done!"
    }

    FileDialog {
        id: fileDialog
        title: "Please choose csv file"
        folder: shortcuts.home
        selectExisting: false
        nameFilters: [ "csv files (*.csv)" ]
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            var filePath = fileDialog.fileUrl.toString().replace("file:///", "")
            dataModel.generatePoints(filePath, txtCount.text, txtMin.text, txtMax.text)
            messageDialog.open()
        }
    }

    Column{
        Row {
            spacing: 10
            Label{
                text: "Generate count:"
            }

            TextField {
                id: txtCount
                validator: IntValidator {bottom: 1; top: 10000000}
                width: 100
                text: "500"
            }
        }
        Row {
            spacing: 10
            Label{
                text: "Minimum data:"
            }

            TextField {
                id: txtMin
                validator: IntValidator {bottom: 1; top: 10000000}
                width: 100
                text: "0"
            }
        }
        Row {
            spacing: 10
            Label{
                text: "Maximum data"
            }

            TextField {
                id: txtMax
                validator: IntValidator {bottom: 1; top: 10000000}
                width: 100
                text: "100"
            }
        }

        Button{
            text: "generate"
            onClicked: {
//                fileDialog.open()
                dataModel.generatePoints("", txtCount.text, txtMin.text, txtMax.text)
            }
        }
    }

    GenerateData {
        id: dataModel
    }
}
