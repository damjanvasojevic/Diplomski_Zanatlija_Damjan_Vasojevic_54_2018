part of 'user_bloc.dart';

@immutable
abstract class UserEvent extends Equatable {}

class CreateUserEvent extends UserEvent {
  final User user;

  CreateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class AutoLoginUserEvent extends UserEvent {
  final BuildContext context;
  final String phoneNumber;
  final String password;
  AutoLoginUserEvent(
    this.context, {
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [context, phoneNumber, password];
}

class LoginUserEvent extends UserEvent {
  final BuildContext context;
  final String phoneNumber;
  final String password;
  LoginUserEvent(
    this.context, {
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [context, phoneNumber, password];
}

class UpdateUserEvent extends UserEvent {
  final User user;

  UpdateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class NotifyUserEvent extends UserEvent {
  final User user;

  NotifyUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}
