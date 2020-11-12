
state Combat in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Hunt - State Combat");

    this.Combat_Main();
  }

  entry function Combat_Main() {
    // to know if it's an ambush
    if (parent.bait_moves_towards_player) {
      this.playAmbushScene();
    }

    this.makeEntitiesTargetPlayer();
    this.waitUntilPlayerFinishesCombat();

    parent
      .master
      .requestOutOfCombatAction(OutOfCombatRequest_TROPHY_CUTSCENE);

    this.Combat_goToNextState();
  }

  private latent function playAmbushScene() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    var look_at_position: Vector;

    if (isPlayerBusy()) {
      return;
    }
    
    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = theCamera.GetCameraPosition() + Vector(0, 0, 1);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    look_at_position = parent.getRandomEntity().GetWorldPosition();
    scene.look_at_target_static = look_at_position + Vector(0, 0, 0);

    scene.velocity_type = RER_CameraVelocityType_FORWARD;
    scene.velocity = Vector(0.001, 0.001, 0);

    scene.duration = 0.5;
    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    camera = RER_getStaticCamera();

    thePlayer.PlayVoiceset( 90, "BattleCryBadSituation" );
    camera.playCameraScene(scene, true);
  }

  private latent function makeEntitiesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'monsters',
        AGP_Default
      );

      if (((CActor)parent.entities[i]).GetTarget() != thePlayer) {
        ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
      }
    }
  }

  latent function waitUntilPlayerFinishesCombat() {
    // sleep a bit before entering the loop, to avoid a really fast loop if the
    // player runs away from the monster
    Sleep(3);

    // 1. we wait until the player is out of combat
    // the && is important, because it allows the player to flee the combat
    // and if he flees far enough and get out of combat it will go back to
    // the wandering state.
    while (!parent.areAllEntitiesDead()) {
      this.makeEntitiesTargetPlayer();

      Sleep(1);
    }
  }

  latent function Combat_goToNextState() {
    if (parent.areAllEntitiesDead()) {
      parent.GotoState('Ending');
    }
    else {
      parent.GotoState('Wandering');
    }
  }
}