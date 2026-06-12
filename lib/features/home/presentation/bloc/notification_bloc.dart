import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import 'notification_event.dart';
import 'notification_state.dart';

export 'notification_event.dart';
export 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationBloc({
    required NotificationRemoteDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource,
        super(NotificationInitial()) {
    on<WatchNotificationsEvent>(_onWatchNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkAsRead);
    on<UpdateNotificationsStateEvent>(_onUpdateNotificationsState);
  }

  Future<void> _onWatchNotifications(
      WatchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final notifications = await _remoteDataSource.getNotifications(event.userId);
      emit(NotificationLoaded(notifications));
    } catch (error) {
      emit(NotificationError(error.toString()));
    }
  }

  Future<void> _onMarkAsRead(
      MarkNotificationAsReadEvent event, Emitter<NotificationState> emit) async {
    try {
      await _remoteDataSource.markAsRead(event.notificationId);
      // Re-fetch or update state locally if userId is available in the bloc state or event
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void _onUpdateNotificationsState(
      UpdateNotificationsStateEvent event, Emitter<NotificationState> emit) {
    emit(NotificationLoaded(event.notifications));
  }
}
