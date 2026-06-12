import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class WatchNotificationsEvent extends NotificationEvent {
  final String userId;
  const WatchNotificationsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;
  const MarkNotificationAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class UpdateNotificationsStateEvent extends NotificationEvent {
  final List<NotificationEntity> notifications;
  const UpdateNotificationsStateEvent(this.notifications);

  @override
  List<Object?> get props => [notifications];
}
