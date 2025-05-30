import 'dart:async';
import 'package:mixin_logger/mixin_logger.dart';
import 'package:win_toast/win_toast.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  Future<bool> initializeWinToast() async {
    final ret = await WinToast.instance().initialize(
      aumId: 'one.mixin.WinToastExample3',
      displayName: 'Notificaciones IW',
      iconPath: '',
      clsid: '936C39FC-6BBC-4A57-B8F8-7C627E401B2F',
    );
    return ret;
  }

  Future<void> sendNotificationWithReply() async {
    const xml = """
<?xml version="1.0" encoding="UTF-8"?>
<toast launch="action=viewConversation&amp;conversationId=9813">
    <visual>
      <binding template="ToastGeneric">
          <text>Alexey te mandó un recordatorio.</text>
          <text>Recuerda checar si el perro sigue vivo.</text>
      </binding>
    </visual>
    <actions>
      <input id="tbReply" type="text" placeHolderContent="Escribe una contestación" />
      <action content="Contestar" activationType="background" arguments="action=reply&amp;conversationId=9813" />
      <action content="Ok" activationType="background" arguments="action=like&amp;conversationId=9813" />
    </actions>
</toast>
""";
    try {
      await WinToast.instance().showCustomToast(xml: xml);
    } catch (error, stacktrace) {
      i('showCustomToast error: $error, $stacktrace');
    }
  }

  Future<void> sendSimpleNotification() async {
    try {
      await WinToast.instance().showToast(
        toast: Toast(
          duration: ToastDuration.short,
          launch: 'action=viewConversation&conversationId=9813',
          children: [
            ToastChildAudio(source: ToastAudioSource.defaultSound),
            ToastChildVisual(
              binding: ToastVisualBinding(
                children: [
                  ToastVisualBindingChildText(text: 'HelloWorld', id: 1),
                  ToastVisualBindingChildText(text: 'by win_toast', id: 2),
                ],
              ),
            ),
            ToastChildActions(children: [
              ToastAction(
                content: "Close",
                arguments: "close_argument",
              )
            ]),
          ],
        ),
      );
    } catch (error, stacktrace) {
      i('showTextToast error: $error, $stacktrace');
    }
  }

  NotificationModel? processNotificationEvent(dynamic event) {
    String? reply;
    if (event.userInput != null && event.userInput!.isNotEmpty) {
      reply = event.userInput!['tbReply'];
    } else {
      final match = RegExp(r'tbReply: (.*?)[},]').firstMatch(event.toString());
      reply = match?.group(1);
    }

    if (reply != null && reply.isNotEmpty) {
      return NotificationModel(
        id: '9813', 
        title: 'Notificación con respuesta',
        body: 'El usuario respondió: $reply',
        reply: reply,
      );
    }
    return null;
  }
}