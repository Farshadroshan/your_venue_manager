 
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:your_venue_manager/features/authentication/model/manager_model.dart';
// import 'package:your_venue_manager/features/authentication/repository/manager_auth_repository.dart';

// part 'manager_auth_event.dart';
// part 'manager_auth_state.dart';

// class ManagerAuthBloc extends Bloc<ManagerAuthEvent, ManagerAuthState> {
//   ManagerAuthBloc() : super(ManagerAuthInitial()) {
//     // on<ManagerAuthEvent>((event, emit) {
//     //   // TODO: implement event handler
//     // });

//     on<RegisterManagerEvent>(_registerManager);
//   }

//   final repository = ManagerAuthRepository();
//   Future<void> _registerManager(
//     RegisterManagerEvent event,
//     Emitter<ManagerAuthState> emit,
//   ) async {
//     emit(ManagerLoading());

//     try {
//       await repository.registerManager(
//         name: event.name,
//         email: event.email,
//         phone: event.phone,
//         password: event.password,
//       );

//       emit(ManagerSuccess());
//     } catch (e) {
//       emit(
//         ManagerFailure(
//           e.toString(),
//         ),
//       );
//     }
//   }
// }


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_venue_manager/features/authentication/model/manager_model.dart';
import 'package:your_venue_manager/features/authentication/repository/manager_auth_repository.dart';

part 'manager_auth_event.dart';
part 'manager_auth_state.dart';

class ManagerAuthBloc
    extends Bloc<ManagerAuthEvent, ManagerAuthState> {
  final ManagerAuthRepository repository;

  ManagerAuthBloc({
    required this.repository,
  }) : super(const ManagerAuthInitial()) {
    on<RegisterManagerEvent>(_registerManager);
    on<LoginManagerEvent>(_loginManager);
    on<LogoutManagerEvent>(_logoutManager);
  }

  Future<void> _registerManager(
    RegisterManagerEvent event,
    Emitter<ManagerAuthState> emit,
  ) async {
    emit(const ManagerAuthLoading());

    try {
      await repository.registerManager(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      );

      emit(const ManagerRegistrationSuccess());
    } on ManagerAuthException catch (error) {
      emit(
        ManagerAuthFailure(
          message: error.message,
        ),
      );
    } catch (_) {
      emit(
        const ManagerAuthFailure(
          message: "Manager registration failed.",
        ),
      );
    }
  }

  Future<void> _loginManager(
    LoginManagerEvent event,
    Emitter<ManagerAuthState> emit,
  ) async {
    emit(const ManagerAuthLoading());

    try {
      final ManagerModel manager =
          await repository.loginManager(
        email: event.email,
        password: event.password,
      );

      emit(
        ManagerLoginSuccess(
          manager: manager,
        ),
      );
    } on ManagerAuthException catch (error) {
      emit(
        ManagerAuthFailure(
          message: error.message,
        ),
      );
    } catch (_) {
      emit(
        const ManagerAuthFailure(
          message: "Manager login failed.",
        ),
      );
    }
  }

  Future<void> _logoutManager(
    LogoutManagerEvent event,
    Emitter<ManagerAuthState> emit,
  ) async {
    emit(const ManagerAuthLoading());

    try {
      await repository.logoutManager();

      emit(const ManagerLogoutSuccess());
    } on ManagerAuthException catch (error) {
      emit(
        ManagerAuthFailure(
          message: error.message,
        ),
      );
    } catch (_) {
      emit(
        const ManagerAuthFailure(
          message: "Manager logout failed.",
        ),
      );
    }
  }
}
