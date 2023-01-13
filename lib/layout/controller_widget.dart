import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/widget/controller_button.dart';

class ControllerWidget extends StatelessWidget {
  const ControllerWidget({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    PlayerData playerData =
        GlobalGameReference().gameReference.worldData.playerData;
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ControllerButtonWidget(
                  path: 'assets/controller/top_left_button.png',
                  onTap: () {
                    playerData.componentMotionState =
                        ComponentMotionState.jumpingLeft;
                  },
                ),
                ControllerButtonWidget(
                  path: 'assets/controller/left_button.png',
                  onTap: () {
                    playerData.componentMotionState =
                        ComponentMotionState.walkingLeft;
                  },
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ControllerButtonWidget(
                  path: 'assets/controller/top_right_button.png',
                  onTap: () {
                    playerData.componentMotionState =
                        ComponentMotionState.jumpingRight;
                  },
                ),
                ControllerButtonWidget(
                  path: 'assets/controller/right_button.png',
                  onTap: () {
                    playerData.componentMotionState =
                        ComponentMotionState.walkingRight;
                  },
                ),
              ],
            ),
            // ControllerButtonWidget(
            //   path: 'assets/controller/center_button.png',
            //   onTap: () async {
            //     playerData.componentMotionState = ComponentMotionState.jumping;
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
