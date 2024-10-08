part of 'push_notification_bloc.dart';

/// Push notification state
sealed class PushNotificationState {
  const PushNotificationState();
}

/// Push notification initial state
final class PushNotificationInitial extends PushNotificationState {
  /// Push notification initial state
  const PushNotificationInitial();
}

/// Push notification received state
final class PushNotificationReceived extends PushNotificationState {
  /// Push notification received state
  final String title;

  /// Push notification received state
  final String body;

  /// Push notification received state
  final PushNotificationPayload payload;

  /// Push notification received state
  final String? linkMobile;

  /// Push notification received state
  PushNotificationReceived({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });

  /// Push notification opened state
  DidUserOpenedNotificationEvent opened() {
    return DidUserOpenedNotificationEvent(
      title: title,
      body: body,
      payload: payload,
      linkMobile: linkMobile,
    );
  }
}

/// Push notification opened state
final class PushNotificationOpened extends PushNotificationState {
  /// Push notification received state
  final String title;

  /// Push notification received state
  final String body;

  /// Push notification received state
  final PushNotificationPayload payload;

  /// Push notification received state
  final String? linkMobile;

  /// Push notification opened state
  const PushNotificationOpened({
    required this.title,
    required this.body,
    required this.payload,
    this.linkMobile,
  });
}
