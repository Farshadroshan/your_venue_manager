part of 'manager_auth_bloc.dart';

// sealed class ManagerAuthState extends Equatable {
//   const ManagerAuthState();
  
//   @override
//   List<Object> get props => [];
// }

// final class ManagerAuthInitial extends ManagerAuthState {}

// // abstract class ManagerAuthState {}

// class ManagerInitial extends ManagerAuthState {}

// class ManagerLoading extends ManagerAuthState {}

// class ManagerSuccess extends ManagerAuthState {}

// class ManagerFailure extends ManagerAuthState {
//   final String error;

//   ManagerFailure(this.error);
// }



// part of 'manager_auth_bloc.dart';

sealed class ManagerAuthState extends Equatable {
  const ManagerAuthState();

  @override
  List<Object> get props => [];
}

final class ManagerAuthInitial extends ManagerAuthState {
  const ManagerAuthInitial();
}

final class ManagerAuthLoading extends ManagerAuthState {
  const ManagerAuthLoading();
}

final class ManagerRegistrationSuccess extends ManagerAuthState {
  const ManagerRegistrationSuccess();
}

final class ManagerLoginSuccess extends ManagerAuthState {
  final ManagerModel manager;

  const ManagerLoginSuccess({
    required this.manager,
  });

  @override
  List<Object> get props => [manager];
}

final class ManagerLoginPending extends ManagerAuthState{
  final ManagerModel manager;

  const ManagerLoginPending({required this.manager});

  @override
  List<Object> get props => [manager];
}

final class ManagerLogoutSuccess extends ManagerAuthState {
  const ManagerLogoutSuccess();
}

final class ManagerAuthFailure extends ManagerAuthState {
  final String message;

  const ManagerAuthFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}