import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

class PlayerComponent extends SpriteAnimationComponent with CollisionCallbacks {
  bool isFacingRight = true;
  double yVelocity = 0;
  final String playerIdlePath =
      'sprite_sheets/player/player_idle_sprite_sheet.png';
  final String playerWalkingPath =
      'sprite_sheets/player/player_walking_sprite_sheet.png';
  final PlayerData playerData =
      GlobalGameReference().gameReference.worldData.playerData;

  late SpriteSheet playerIdleSpriteSheet;
  late SpriteSheet playerWalkingSpriteSheet;
  late SpriteAnimation spriteIdleAnimation;
  late SpriteAnimation spriteWalkingAnimation;
  bool isCollidingBottom = false;
  bool isCollidingLeft = false;
  bool isCollidingRight = false;
  double jumpForce = 0;

  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox());
    priority = 100;
    anchor = Anchor.bottomCenter;
    playerIdleSpriteSheet = SpriteSheet(
        image: await Flame.images.load(playerIdlePath),
        srcSize: Vector2.all(60));
    playerWalkingSpriteSheet = SpriteSheet(
        image: await Flame.images.load(playerWalkingPath),
        srcSize: Vector2.all(60));
    spriteIdleAnimation =
        playerIdleSpriteSheet.createAnimation(row: 0, stepTime: 0.5);
    spriteWalkingAnimation =
        playerWalkingSpriteSheet.createAnimation(row: 0, stepTime: 0.2);
    size = GameMethods().blockSize * 1.5;
    position = Vector2(200, 700);
    animation = spriteIdleAnimation;
    return super.onLoad();
  }

  @override
  void update(double dt) async {
    movementLogic(dt);
    fallingLogic(dt);
    setAllCollisionToDefault();
    if (jumpForce > 0){
      position.y -= jumpForce;
      jumpForce -= GameMethods().blockSize.x * 0.15;
    }
    super.update(dt);
  }

  void fallingLogic(double dt){
    if (!isCollidingBottom) {
      if (yVelocity < (GameMethods().gravity * dt) * 5) {
        position.y += yVelocity;
        yVelocity += GameMethods().gravity * dt;
      } else {
        position.y += yVelocity;
      }
    }
  }

  void setAllCollisionToDefault(){
    isCollidingBottom = false;
    isCollidingRight = false;
    isCollidingLeft = false;
  }

  void movementLogic(double dt) {
    if (playerData.componentMotionState == ComponentMotionState.walkingLeft &&
        !isCollidingLeft) {
      position.x -= (playerSpeed * GameMethods().blockSize.x) * dt;
      animation = spriteWalkingAnimation;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
    } else if (playerData.componentMotionState ==
            ComponentMotionState.walkingRight &&
        !isCollidingRight) {
      position.x += (playerSpeed * GameMethods().blockSize.x) * dt;
      animation = spriteWalkingAnimation;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
    } else if (playerData.componentMotionState == ComponentMotionState.idle) {
      animation = spriteIdleAnimation;
    } else if (playerData.componentMotionState == ComponentMotionState.jumping) {
      jumpForce = GameMethods().blockSize.x;
    } else if (playerData.componentMotionState == ComponentMotionState.jumpingLeft) {
      jumpForce = GameMethods().blockSize.x;
      position.x -=  GameMethods().blockSize.x * 0.6;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
    } else if (playerData.componentMotionState == ComponentMotionState.jumpingRight) {
      jumpForce = GameMethods().blockSize.x;
      position.x += GameMethods().blockSize.x * 0.6;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    for (var individualIntersectionPoint in intersectionPoints) {
      if (individualIntersectionPoint.y > (position.y - (size.y * 0.4)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              size.x * 0.3) {
        isCollidingBottom = true;
      }
      if (individualIntersectionPoint.y < (position.y - (size.y * 0.4))) {
        if (individualIntersectionPoint.x > position.x) {
          isCollidingRight = true;
          yVelocity = 0;
        } else {
          isCollidingLeft = true;
        }
      }
    }
  }
}
