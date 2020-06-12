import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.LocalStorage 2.0
import "../../Component"

Page {
    id: chatPage

    property string s_username  //聊天对象名
    property int s_userid       //聊天对象ID

    focus: true
    Keys.onBackPressed: {
        event.accepted = true;
        try { stackView.pop(); }  catch(e) { }
    }

    Constant { id: constant }

    topBar: TopBar {
        id: topBar

        //! aviod looping binding
        Item { anchors.fill: parent }
        RowLayout {
            anchors.fill: parent
            spacing: 10

            Item { width:  topBar.height - 2; height: width }

            IconButton {
                height: topBar.height - 2
                width: topBar.height - 2
                anchors.verticalCenter: parent.verticalCenter
                activeIconSource: constant.backActiveIcon
                inactiveIconSource: constant.backInactiveIcon
                onClicked: {
                    try { stackView.pop(); }  catch(e) { }
                }

                Separator {
                    color: "black"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // such as menuBar

        Row {
            parent: topBar
            anchors.left: parent.left
            anchors.leftMargin: (topBar.height - 2) * 1.5
            anchors.fill: parent
            Label {
                text: s_username
                // Layout.alignment: Qt.AlignRight
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

    }

    bottomBar: BottomBar {
        RowLayout {
            anchors.fill: parent

            spacing: 5

            IconButton {
                width: topBar.height - 2
                height: topBar.height - 2
                activeIconSource: constant.soundActiveIcon
                inactiveIconSource: constant.soundInactiveIcon
            }

            Item {
                Layout.fillWidth: true
                implicitHeight: textInput.implicitHeight
                SampleTextArea {
                    id: textInput
                    width: parent.width
                    implicitHeight: {
                        if(lineCount >= 2) {
                            (topBar.height - 2) * 2
                        } else {
                            (topBar.height- 2) * lineCount
                        }
                    }
                    IconButton {
                        width: topBar.height * 0.9
                        height: topBar.height * 0.9
                        activeIconSource: constant.emoticonActiveIcon
                        inactiveIconSource: constant.emoticonInactiveIcon
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                    }

                }
            }

            SampleButton {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Send")
                onClicked:  {
                    if(textInput.text != "" ) {
                        //传入用户ID,消息接收端ID,时间,消息内容
                        message_listModel.add([profile.account,s_userid,"1",textInput.text])
                       // chatModel.append({"chatContext":textInput.text});
                       // message_listModel.append({"chatContext":content})
                        //chatContentText.text:
                        textInput.text = "";
                    }
                }
            }
            Item { width: 5; height: 5 }
        }
    }

    ListView {
        id: chatListView
        anchors.fill: parent
//        model: ListModel {
//            id: chatModel
//            //                ListElement {
//            //                    chatContext: ""
//            //                }
//        }
        model:message_listModel

        spacing: 20

        readonly property int itemSpacing: 10
        readonly property int headPortraitPictureWidth: 60

        readonly property int
        chatContentAreaWidth: chatListView.width - chatListView.headPortraitPictureWidth*2 - 2 *chatListView.itemSpacing

        delegate: chatAreaComponent
    }


    Component {
        id: chatAreaComponent
        Row {
            id: chatArea
            spacing: chatListView.itemSpacing
            Image {
                // 头像
                id: headPortraitPic1
                width: chatListView.headPortraitPictureWidth
                height: chatListView.headPortraitPictureWidth
                sourceSize: Qt.size(width, height)
                source: constant.testPic
                opacity: 0
            }

            Item {
                id: chatContentArea
                width: chatListView.chatContentAreaWidth
                height: chatContentText.contentHeight > 60 ? chatContentText.contentHeight : 60

                Rectangle {
                    border.width: 1
                    border.color: "#ccc"
                    anchors.right: parent.right
                    height: parent.height
                    color: "green"
                    width: chatContentText.contentWidth > 200 ? chatContentText.contentWidth : 200
                    Text {
                        id: chatContentText
                        width: 300
                        anchors.right: parent.right
                        anchors.rightMargin: chatListView.itemSpacing
                        anchors.top: parent.top
                        anchors.topMargin: chatListView.itemSpacing
                        // anchors.centerIn: parent
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        text: content
                        font.pointSize: constant.normalFontPointSize
                        font.family: "微软雅黑"
                    }
                }
            }

            Image {
                // 头像
                id: headPortraitPic2
                width: chatListView.headPortraitPictureWidth
                height: chatListView.headPortraitPictureWidth
                sourceSize: Qt.size(width, height)
                source: constant.testPic
            }
        }
    }
}

