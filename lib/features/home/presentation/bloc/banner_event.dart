import 'package:equatable/equatable.dart';

abstract class BannerEvent extends Equatable {
  const BannerEvent();

  @override
  List<Object?> get props => [];
}

class WatchBannersEvent extends BannerEvent {}

class UpdateBannersStateEvent extends BannerEvent {
  final List<dynamic> banners;
  const UpdateBannersStateEvent(this.banners);

  @override
  List<Object?> get props => [banners];
}
