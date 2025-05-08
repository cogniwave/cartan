import 'package:equatable/equatable.dart';

abstract class UrlLauncherState extends Equatable {
  const UrlLauncherState();

  @override
  List<Object?> get props => [];
}

class UrlLauncherInitial extends UrlLauncherState {}

class UrlLaunchLoading extends UrlLauncherState {}

class UrlLaunchSuccess extends UrlLauncherState {}

class UrlLaunchFailure extends UrlLauncherState {
  final String messageKey;

  const UrlLaunchFailure(this.messageKey);

  @override
  List<Object?> get props => [messageKey];
}

class NoMapAppsInstalled extends UrlLauncherState {
  const NoMapAppsInstalled();

  @override
  List<Object?> get props => [];
}