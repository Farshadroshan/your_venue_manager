 import 'package:equatable/equatable.dart';

class PasswordVisibilityState extends Equatable {
  final bool isPasswordObscure;
  final bool isConfirmPasswordObscure;

  const PasswordVisibilityState({
    this.isPasswordObscure = true,
    this.isConfirmPasswordObscure = true,
  });

  PasswordVisibilityState copyWith({
    bool? isPasswordObscure,
    bool? isConfirmPasswordObscure,
  }) {
    return PasswordVisibilityState(
      isPasswordObscure:
          isPasswordObscure ?? this.isPasswordObscure,
      isConfirmPasswordObscure:
          isConfirmPasswordObscure ??
          this.isConfirmPasswordObscure,
    );
  }

  @override
  List<Object> get props => [
        isPasswordObscure,
        isConfirmPasswordObscure,
      ];
}