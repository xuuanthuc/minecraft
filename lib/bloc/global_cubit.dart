import 'package:flutter_bloc/flutter_bloc.dart';

import '../global/global_game_reference.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());
}
