import 'package:awesome_notifications/awesome_notifications.dart';

class notificationService {
  static Future<void> initializedNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'alert',
            channelName: 'alert',
            channelDescription: 'Notification',
            playSound: true,
            onlyAlertOnce: true,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
          )
        ],
        debug: true);
    await AwesomeNotifications().isNotificationAllowed().then((value) async {
      if (!value) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceive,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  static Future<void> onActionReceive(ReceivedAction onActionReceived) async {
    final payload = onActionReceived.payload ?? {};
    if (payload["navigate"] == "true") {
      print("Action done");
    }
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  static Future<void> createNotificationFromJsonData({
    required String title,
    required String body,
    final String? summary,
    final String? bigPicture,
    final String? largeIcon,
    final Map<String, String>? payload,
    final ActionType? actionType,
    final NotificationLayout? notificationLayout,
    final NotificationCategory? notificationCategory,
    final List<NotificationActionButton>? actionButton,
    final bool schedule = false,
    final int? hours,
    final int? minutes,
    final int? seconds,
    final bool isrepeat = false,
    final bool preciseAlarm = false,
  }) async {
    assert(!schedule || (schedule));
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'alert',
            title: title,
            body: body,
            actionType: actionType ?? ActionType.Default,
            summary: summary ?? "",
            category: notificationCategory ?? NotificationCategory.Message,
            payload: payload,
            largeIcon: largeIcon),
        actionButtons: actionButton,
        schedule: schedule
            ? NotificationCalendar(
                allowWhileIdle: true,
                hour: hours,
                minute: minutes,
                second: seconds,
                preciseAlarm: preciseAlarm,
                repeats: isrepeat,
              )
            : null);
  }
}
