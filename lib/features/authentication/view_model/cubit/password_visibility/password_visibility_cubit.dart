import 'package:bloc/bloc.dart';
import 'package:your_venue_manager/features/authentication/view_model/cubit/password_visibility/password_visibility_state.dart';

// part 'password_visibility_state.dart';

class PasswordVisibilityCubit extends Cubit<PasswordVisibilityState> {
  PasswordVisibilityCubit() : super(PasswordVisibilityState());

  void togglePassword() {
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  void toggleConfirmPassword() {
    emit(
      state.copyWith(isConfirmPasswordObscure: !state.isConfirmPasswordObscure),
    );
  }
}
