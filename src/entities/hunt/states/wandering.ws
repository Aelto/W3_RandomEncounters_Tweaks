
state Wandering in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntEntity - State Wandering");
    this.Wandering_main();
  }

  entry function Wandering_main() {
    this.resetEntitiesActions();
    this.makeEntitiesMoveTowardsBait();
    this.resetEntitiesActions();

    parent.GotoState('Combat');
  }

  latent function makeEntitiesMoveTowardsBait() {
    var distance_from_player: float;
    var distance_from_bait: float;
    var current_entity: CEntity;
    var current_heading: float;
    var i: int;

    do {
      if (parent.areAllEntitiesDead()) {
        parent.GotoState('Ending');

        break;
      }

      // i'm doing it in reverse because why not?
      // i thought to myself, isn't it better to start from the higher end
      // and go lower.
      // Is it unnecessary micro optimization? Totally!
      for (i = parent.entities.Size() - 1; i >= 0; i -= 1) {
        current_entity = parent.entities[i];

        distance_from_player = VecDistance(
          current_entity.GetWorldPosition(),
          thePlayer.GetWorldPosition()
        );

        if (distance_from_player > parent.entity_settings.kill_threshold_distance) {
          LogChannel('modRandomEncounters', "killing entity - threshold distance reached: " + parent.entity_settings.kill_threshold_distance);

          parent.killEntity(current_entity);

          continue;
        }

        if (distance_from_player < 15
        || ((CActor)current_entity).GetTarget() == thePlayer && distance_from_player < 20) {
          // leave the function, it will automatically enter in the Combat state
          // and the creatures will attack the player.
          return;
        }

        distance_from_bait = VecDistanceSquared(
          current_entity.GetWorldPosition(),
          parent.bait_entity.GetWorldPosition()
        );

        if (distance_from_bait < 5 * 5) {
          this.teleportBaitEntity();
        }

        // ((CNewNPC)parent.entities[i]).ForgetAllActors();


        if (!((CActor)current_entity).IsMoving()) {
          ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
            'monsters',
            AGP_Default
          );

          ((CActor)current_entity).ActionCancelAll();

          ((CNewNPC)current_entity)
            .NoticeActor((CActor)parent.bait_entity);
        }

        // ((CActor)current_entity)
        //   .GetMovingAgentComponent()
        //   .SetGameplayRelativeMoveSpeed(1);

        // current_heading = VecHeading(parent.bait_entity.GetWorldPosition() - current_entity.GetWorldPosition());

        // ((CActor)current_entity)
        //   .GetMovingAgentComponent()
        //   .SetGameplayMoveDirection(current_heading);

        parent.trail_maker.addTrackHere(
          current_entity.GetWorldPosition(),
          current_entity.GetWorldRotation()
        );
      }

      // to keep the bait near the player at all time
      if (parent.bait_moves_towards_player) {
        this.teleportBaitEntity();
      }

      Sleep(0.5);
    } while (true);
  }

  private function teleportBaitEntity() {
    var new_bait_position: Vector;
    var new_bait_rotation: EulerAngles;

    // NDEBUG("towards player " + parent.bait_moves_towards_player);

    if (parent.bait_moves_towards_player) {
      new_bait_position = thePlayer.GetWorldPosition();
      new_bait_rotation = parent.bait_entity.GetWorldRotation();
    }
    else {
      new_bait_position = parent.getRandomEntity().GetWorldPosition() + VecConeRand(parent.GetHeading(), 90, 10, 20);
      new_bait_rotation = parent.bait_entity.GetWorldRotation();
      new_bait_rotation.Yaw += RandRange(-20,20);
    }
    
    parent.bait_entity.TeleportWithRotation(
      new_bait_position,
      new_bait_rotation
    );
  }

  latent function resetEntitiesActions() {
    var i: int;
    var current_entity: CEntity;
    
    for (i = parent.entities.Size() - 1; i >= 0; i -= 1) {
      current_entity = parent.entities[i];

      ((CActor)current_entity).ActionCancelAll();

      ((CActor)current_entity)
          .GetMovingAgentComponent()
          .ResetMoveRequests();

      ((CActor)current_entity)
          .GetMovingAgentComponent()
          .SetGameplayMoveDirection(0.0f);
    }
  }
}