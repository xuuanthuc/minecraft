import 'package:flutter/material.dart';

import '../global/global_game_reference.dart';
import '../global/player_data.dart';

class ControllerButtonWidget extends StatefulWidget {
  final String path;
  final Function onTap;

  const ControllerButtonWidget({
    Key? key,
    required this.path,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ControllerButtonWidget> createState() => _ControllerButtonWidgetState();
}

class _ControllerButtonWidgetState extends State<ControllerButtonWidget> {
  bool isPress = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GestureDetector(
          onTapDown: (d) {
            setState(() {
              isPress = true;
              widget.onTap();
            });
          },
          onTapUp: (d) {
            setState(() {
              isPress = false;
              GlobalGameReference().gameReference.worldData.playerData.componentMotionState = ComponentMotionState.idle;
            });
          },
          onTapCancel: (){
            setState(() {
              isPress = false;
              GlobalGameReference().gameReference.worldData.playerData.componentMotionState = ComponentMotionState.idle;
            });
          },
          child: Opacity(
            opacity: isPress ? 0.5 : 1,
            child: SizedBox(
              height: screenSize.height / 8,
              width: screenSize.height / 8,
              child: Image.asset(widget.path),
            ),
          ),
        ));
  }
}
