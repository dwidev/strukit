import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/flushbar_extension.dart';
import '../../bloc/authentication_bloc.dart';

class AuthPageListener extends StatelessWidget {
  const AuthPageListener({super.key, required this.builder, this.onSuccess});

  final Function(BuildContext context, AuthenticationBloc prov) builder;
  final Function(BuildContext context, AuthenticationState state)? onSuccess;

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.isLoading) {
          context.loading();
        } else if (!state.isLoading) {
          context.pop();
        }

        if (onSuccess == null) {
          if (state is AuthenticationSignSuccess) {
          } else if (state is AuthenticationSignSuccessNotRegistered) {}
        } else {
          onSuccess?.call(context, state);
        }

        if (state is AuthenticationSignError) {
          context.showWarningFlush(message: state.error.toString());
        }
      },
      child: builder(context, authBloc),
    );
  }
}
