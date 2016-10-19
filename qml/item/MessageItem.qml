import QtQuick 2.4
import LibQTelegram 1.0
import "../component/message"

Item
{
    property var context
    property var tgDialog
    property Message tgMessage
    property real maxWidth

    id: messageitem
    height: content.height

    width: {
        if(context.telegram.constructorIs(tgMessage, Message.CtorMessageService))
            return maxWidth;

        var w = Math.max(lblhiddenfrom.contentWidth, lblhiddenmessage.contentWidth, mediamessageitem.contentWidth)
        return Math.min(w, maxWidth);
    }

    anchors {
        right: !tgMessage.isOut ? undefined : parent.right
        left: tgMessage.isOut ? undefined : parent.left
        rightMargin: Theme.paddingMedium
        leftMargin: Theme.paddingMedium
    }

    MessageBubble
    {
        anchors { fill: parent; margins: -Theme.paddingSmall }
        tgMessage: messageitem.tgMessage

        visible: {
            if(mediamessageitem.isSticker || mediamessageitem.isAnimated)
                return false;

            return !context.telegram.constructorIs(tgMessage, Message.CtorMessageService);
        }
    }

    Column
    {
        id: content
        width: parent.width

        Text { id: lblhiddenfrom; text: context.telegram.messageFrom(tgMessage); visible: false }
        Text { id: lblhiddenmessage; text: context.telegram.messageText(tgMessage); visible: false }

        Text
        {
            id: lblfrom
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            visible: context.telegram.dialogIsChat(tgDialog) && !tgMessage.isOut
            text: lblhiddenfrom.text
        }

        MediaMessageItem
        {
            id: mediamessageitem
            message: messageitem.tgMessage
            size: parent.width

            locationDelegate: function(latitude, longitude){
                return context.locationThumbnail(latitude, longitude, maxWidth, maxWidth, 14);
            }
        }

        MessageText
        {
            id: lblmessage
            width: parent.width
            emojiPath: context.qtgram.emojiPath
            rawText: lblhiddenmessage.text
            wrapMode: Text.Wrap
            font { italic: context.telegram.constructorIs(tgMessage, Message.CtorMessageService) }

            color: {
                if(context.telegram.constructorIs(tgMessage, Message.CtorMessageService))
                    return "gray";

                return "black";
            }

            horizontalAlignment: {
                if(context.telegram.constructorIs(tgMessage, Message.CtorMessageService))
                    return Text.AlignHCenter;

                return Text.AlignLeft;
            }
        }
    }
}
