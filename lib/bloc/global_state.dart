part of 'global_cubit.dart';

abstract class GlobalState {
  late GlobalGameReference globalGameReference;

  GlobalState(GlobalState? state) {
    globalGameReference = state?.globalGameReference ?? GlobalGameReference();
  }
}

class GlobalInitial extends GlobalState {
  GlobalInitial({GlobalState? state}) : super(state);
}
