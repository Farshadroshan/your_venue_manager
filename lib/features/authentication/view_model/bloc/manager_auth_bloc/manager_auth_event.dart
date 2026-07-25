part of 'manager_auth_bloc.dart';

// sealed class ManagerAuthEvent extends Equatable {
//   const ManagerAuthEvent();

//   @override
//   List<Object> get props => [];
// }


// class RegisterManagerEvent extends ManagerAuthEvent {
//   final String name;
//   final String email;
//   final String phone;
//   final String password;

//    RegisterManagerEvent({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.password,
//   });
// }


// part of 'manager_auth_bloc.dart';

sealed class ManagerAuthEvent extends Equatable {
  const ManagerAuthEvent();

  @override
  List<Object> get props => [];
}

final class RegisterManagerEvent extends ManagerAuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterManagerEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [
        name,
        email,
        phone,
        password,
      ];
}

final class LoginManagerEvent extends ManagerAuthEvent {
  final String email;
  final String password;

  const LoginManagerEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

final class LogoutManagerEvent extends ManagerAuthEvent {
  const LogoutManagerEvent();
}