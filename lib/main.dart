import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minecraft/bloc/global_cubit.dart';
import 'package:minecraft/layout/game_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(BlocProvider(
    create: (context) => GlobalCubit(),
    child: const MaterialApp(
      home: GameLayout(),
    ),
  ));
}
