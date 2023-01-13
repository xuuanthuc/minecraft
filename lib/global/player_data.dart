class PlayerData {
  ComponentMotionState componentMotionState = ComponentMotionState.idle;
}

enum ComponentMotionState {
  walkingLeft,
  walkingRight,
  idle,
  jumping,
  jumpingLeft,
  jumpingRight,
}
