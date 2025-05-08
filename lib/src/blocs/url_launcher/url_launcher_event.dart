import 'package:equatable/equatable.dart';

abstract class UrlLauncherEvent extends Equatable {
  const UrlLauncherEvent();

  @override
  List<Object?> get props => [];
}

class LaunchWebUrlEvent extends UrlLauncherEvent {
  final String url;

  const LaunchWebUrlEvent(this.url);

  @override
  List<Object?> get props => [url];
}

class LaunchMapEvent extends UrlLauncherEvent {
  final String searchQuery;

  const LaunchMapEvent(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}