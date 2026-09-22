import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/features/settings/interactor/settings_interactor.dart';
import 'package:lotus_ai/features/settings/presenter/settings_bloc.dart';
import 'package:lotus_ai/features/settings/view/ai_settings_screen.dart';

class SettingsRouter {
  SettingsRouter({required SettingsInteractor interactor})
      : _interactor = interactor;

  final SettingsInteractor _interactor;

  Widget buildSettingsView() {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(interactor: _interactor),
      child: AiSettingsScreen(router: this),
    );
  }

  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
