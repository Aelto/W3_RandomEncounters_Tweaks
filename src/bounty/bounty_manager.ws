

class RER_BountyManager {
  var master: CRandomEncounters;
  var bounty_master_manager: RER_BountyMasterManager;

  // the list of hunting grounds for the current bounty.
  var currently_managed_groups: array<RandomEncountersReworkedHuntingGroundEntity>;

  public function init(master: CRandomEncounters) {
    this.master = master;
    this.bounty_master_manager = new RER_BountyMasterManager in this;
  }

  public latent function retrieveBountyGroups() {
    var new_managed_group: RandomEncountersReworkedHuntingGroundEntity;
    var bounty: RER_Bounty;
    var i, k: int;

    // there is no current bounty active in the world.
    if (!this.master.storages.bounty.current_bounty.is_active) {
      return;
    }

    bounty = this.getCurrentBountyCopy();

    for (i = 0; i < bounty.random_data.groups.Size(); i += 1) {
      // it was not spawned earlier so we skip it
      if (!bounty.random_data.groups[i].was_spawned) {
        continue;
      }

      // it was already killed so we skip it too
      if (bounty.random_data.groups[i].was_killed) {
        continue;
      }

      // now if the group was spawned earlier and was not killed it,
      // we create a new hunting group there with the bounty entities around the
      // point.
      new_managed_group = retrieveBountyGroup(bounty.random_data.groups[i], i);

      this.currently_managed_groups.PushBack(new_managed_group);
    }
  }

  public function getCurrentBountyCopy(): RER_Bounty {
    return this.master.storages.bounty.current_bounty;
  }

  // returns the steps at which the seed gains difficulty points
  public function getSeedDifficultyStep(): int {
    return 1000;
  }

  public function getDifficultyForSeed(seed: int): int {
    return (int)(seed / this.getSeedDifficultyStep());
  }

  // returns how much the seed cap is increased by bounty level
  public function getSeedBountyLevelStep(): int {
    return 500;
  }

  public function getMaximumSeed(): int {
    return this.master.storages.bounty.bounty_level * this.getSeedBountyLevelStep();
  }

  // create a new bounty struct with all the data we need to know about the new
  // bounty.
  public function getNewBounty(seed: int): RER_Bounty {
    var bounty: RER_Bounty;

    if (seed <= 0) {
      seed = RandRange(this.getMaximumSeed());
    }

    bounty = RER_Bounty();
    bounty.seed = seed;
    bounty.is_active = true;
    bounty.random_data = this.generateRandomDataForBounty(seed);

    return bounty;
  }

  public function generateRandomDataForBounty(seed: int): RER_BountyRandomData {
    var current_group_data: RER_BountyRandomMonsterGroupData;
    var current_bestiary_entry: RER_BestiaryEntry;
    var rng: RandomNumberGenerator;
    var data: RER_BountyRandomData;
    var number_of_groups: int;
    var i: int;

    // TODO: do something to the seed based on the current world too.
    // so a same seed doesn't give the same result in Skellige, Toussaint or Velen
    rng = (new RandomNumberGenerator in this).setSeed(seed);
    data = RER_BountyRandomData();
    number_of_groups = this.getNumberOfGroupsForSeed(seed);

    for (i = 0; i < number_of_groups; i += 1) {
      current_group_data = RER_BountyRandomMonsterGroupData();

      current_group_data.type = (int)(rng.next() * (int)CreatureMAX);
      
      current_bestiary_entry = this.master.bestiary.entries[current_group_data.type];
      
      current_group_data.count = rollDifficultyFactorWithRng(
        current_bestiary_entry.template_list.difficulty_factor,
        this.master.settings.selectedDifficulty,
        this.master.settings.enemy_count_multiplier
        * current_bestiary_entry.creature_type_multiplier
        // double the amount of creatures at level 100
        * (1 + this.getDifficultyForSeed(seed) * 0.01),
        rng
      );

      current_group_data.position_x = rng.next();
      current_group_data.position_y = rng.next();

      data.groups.PushBack(current_group_data);
    }

    return data;
  }

  // create the new bounty from the bounty struct that contains all the data about
  // the bounty.
  // NOTE: it kills every existing bounty creatures already in the world before
  // creating new ones, in order to cancel the previous bounty if it existed.
  public latent function startBounty(bounty: RER_Bounty) {
    var entities: array<CEntity>;
    var new_managed_group: RandomEncountersReworkedHuntingGroundEntity;
    var i: int;

    theGame.GetEntitiesByTag('RER_BountyEntity', entities);

    for (i = 0; i < entities.Size(); i += 1) {
      ((CNewNPC)entities[i]).Kill('Bounty');
    }

    NLOG("killed " + entities.Size() + " entities");

    if (entities.Size() > 0) {
      NLOG("waiting 10 seconds");

      // to give time to the HuntingGround to notify the manager
      Sleep(10);
    }

    this.currently_managed_groups.Clear();
    
    this.master.storages.bounty.current_bounty = bounty;

    this.master
        .storages
        .bounty
        .save();

    NLOG("starting bounty with " + this.master.storages.bounty.current_bounty.random_data.groups.Size() + " groups");

    for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.groups.Size(); i += 1) {
      new_managed_group = this.spawnBountyGroup(
        this.master.storages.bounty.current_bounty.random_data.groups[i],
        i
      );

      this.currently_managed_groups.PushBack(new_managed_group);

      // don't spawn more than 5 groups at the start.
      // The rest of the groups are spawned the player progresses through the bounty.
      if (i >= 4) {
        break;
      }
    }

    theSound.SoundEvent( 'gui_enchanting_socket_add' );

    Sleep(2);

    RER_tutorialTryShowBounty();

    Sleep(2);

    RER_openPopup(
      "Bounty information",
      this.getInformationMessageAboutCurrentBounty()
    );

    NLOG("bounty started");
  }

  public function getInformationMessageAboutCurrentBounty(): string {
    var group: RER_BountyRandomMonsterGroupData;
    var message: string;
    var i: int;

    message = "The following creatures were seen and now have bounties on their heads:<br />";

    for (i = 0; i < this.master.storages.bounty.current_bounty.random_data.groups.Size(); i += 1) {
      group = this.master.storages.bounty.current_bounty.random_data.groups[i];
      message += " - " + group.count + " ";
      message += " " + getCreatureNameFromCreatureType(this.master.bestiary, group.type) + "<br />";
    }

    message += "<br />Whoever brings their trophies to the bounty master will get a sizable reward";

    return message;
  }

  public latent function progressThroughCurrentBounty() {
    var current_seed: int;
    var random_group: RER_BountyRandomMonsterGroupData;
    var random_group_index: int;
    var new_managed_group: RandomEncountersReworkedHuntingGroundEntity;

    if (!this.master.storages.bounty.current_bounty.is_active) {
      return;
    }

    this.master
        .storages
        .bounty
        .save();

    // if the player has killed enough groups then we consider the bounty finished
    if (!this.hasAnyGroupToKillYet(this.master.storages.bounty.current_bounty)) {
      NLOG("progress - no more groups to kill in the bounty, bounty is finished");

      // we increase the bounty level for the player
      this.increaseBountyLevel();

      // set the bounty as no longer active
      this.master
        .storages
        .bounty
        .current_bounty
        .is_active = false;

      // save the changes
      this.master
        .storages
        .bounty
        .save();

      return;
    }

    // there is still a group to spawn
    if (this.getRandomGroupToSpawn(this.master.storages.bounty.current_bounty, random_group, random_group_index)) {
      NLOG("progress - still one group to spawn, spawning it " + random_group_index);
      new_managed_group = this.spawnBountyGroup(random_group, random_group_index);

      this.currently_managed_groups.PushBack(new_managed_group);
    }
  }

  public function hasAnyGroupToKillYet(bounty: RER_Bounty): bool {
    var i: int;

    for (i = 0; i < bounty.random_data.groups.Size(); i += 1) {
      if (!bounty.random_data.groups[i].was_killed) {
        return true;
      }
    }

    return false;
  }

  public latent function notifyHuntingGroundKilled(group_index: int) {
    this.master
      .storages
      .bounty
      .current_bounty
      .random_data
      .groups[group_index]
      .was_killed = true;

    this.master
        .storages
        .bounty
        .save();


    this.progressThroughCurrentBounty();
  }

  // returns false if it could not find any more group to spawn in the supplied bounty.
  public function getRandomGroupToSpawn(bounty: RER_Bounty, out group_data: RER_BountyRandomMonsterGroupData, out group_index: int): bool {
    var i: int;

    for (i = 0; i < bounty.random_data.groups.Size(); i += 1) {
      if (!bounty.random_data.groups[i].was_spawned) {
        group_data = bounty.random_data.groups[i];
        group_index = i;
        
        return true;
      }
    }

    return false;
  }

  public latent function spawnBountyGroup(group_data: RER_BountyRandomMonsterGroupData, group_index: int): RandomEncountersReworkedHuntingGroundEntity {
    var bestiary_entry: RER_BestiaryEntry;
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var rer_entity_template: CEntityTemplate;
    var entities: array<CEntity>;
    var position: Vector;
    var i: int;

    bestiary_entry = this.master.bestiary.entries[group_data.type];
    position = this.getCoordinatesFromPercentValues(group_data.position_x, group_data.position_y);

    entities = bestiary_entry.spawn(
      this.master,
      position,
      group_data.count,
      , // density
      true, // trophies
      EncounterType_HUNTINGGROUND
    );

    NLOG("bounty group " + group_index + " spawned " + entities.Size() + " entities at " + VecToString(position));

    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );

    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, position, thePlayer.GetWorldRotation());
    rer_entity.activateBountyMode(this, group_index);
    rer_entity.startEncounter(this.master, entities, bestiary_entry);

    for (i = 0; i < entities.Size(); i += 1) {
      if (!entities[i].HasTag('RER_BountyEntity')) {
        entities[i].AddTag('RER_BountyEntity');
      }
    }

    this.master
      .storages
      .bounty
      .current_bounty
      .random_data
      .groups[group_index]
      .was_spawned = true;

    this.master
        .storages
        .bounty
        .save();

    return rer_entity;
  }

  public latent function retrieveBountyGroup(group_data: RER_BountyRandomMonsterGroupData, group_index: int): RandomEncountersReworkedHuntingGroundEntity {
    var rer_entity: RandomEncountersReworkedHuntingGroundEntity;
    var rer_entity_template: CEntityTemplate;
    var entities: array<CGameplayEntity>;
    var filtered_entities: array<CEntity>;
    var position: Vector;
    var i: int;

    position = this.getCoordinatesFromPercentValues(group_data.position_x, group_data.position_y);
    
    rer_entity_template = (CEntityTemplate)LoadResourceAsync(
      "dlc\modtemplates\randomencounterreworkeddlc\data\rer_hunting_ground_entity.w2ent",
      true
    );
    rer_entity = (RandomEncountersReworkedHuntingGroundEntity)theGame.CreateEntity(rer_entity_template, position, thePlayer.GetWorldRotation());

    FindGameplayEntitiesInRange(
      entities,
      rer_entity,
      50, // radius
      50, // max number of entities
      'RandomEncountersReworked_Entity', // tag
      FLAG_ExcludePlayer,
      thePlayer, // target
      'CEntity'
    );

    for (i = 0; i < entities.Size(); i += 1) {
      if (entities[i].HasTag('RER_controlled')) {
        continue;
      }

      entities[i].AddTag('RER_controlled');
      filtered_entities.PushBack((CEntity)entities[i]);
    }
    
    rer_entity.activateBountyMode(this, group_index);
    rer_entity.startEncounter(this.master, filtered_entities, this.master.bestiary.entries[group_data.type]);

    return rer_entity;
  }

  public function getCoordinatesFromPercentValues(percent_x: float, percent_y: float): Vector {
    var min: float;
    var max: float;
    var output: Vector;
    var area: EAreaName;
    var area_string: string;

    area = theGame.GetCommonMapManager().GetCurrentArea();
    // TODO: use real values
    // the min & max values are random values at the moment

    switch (area) {
      case AN_Prologue_Village:
      case AN_Prologue_Village_Winter:
      case AN_Spiral:
      case AN_CombatTestLevel:
      case AN_Wyzima:
      case AN_Island_of_Myst:
        // first the X coordinates
        min = -300;
        max = 300;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -300;
        max = 300;

        output.Y = min + (max - min) * percent_y;
        break;

      case AN_Skellige_ArdSkellig:
        // first the X coordinates
        min = -4000;
        max = 4000;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -4000;
        max = 4000;

        output.Y = min + (max - min) * percent_y;
        break;

      case AN_Kaer_Morhen:
        // first the X coordinates
        min = -4000;
        max = 4000;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -4000;
        max = 4000;

        output.Y = min + (max - min) * percent_y;
        break;

      case AN_NMLandNovigrad:
      case AN_Velen:
        // first the X coordinates
        min = -4000;
        max = 4000;

        output.X = min + (max - min) * percent_x;

        // then the Y coordinates
        min = -4000;
        max = 4000;

        output.Y = min + (max - min) * percent_y;
        break;

      default:
        area_string = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

        if (area_string == "bob") {
          // first the X coordinates
          min = -4000;
          max = 4000;

          output.X = min + (max - min) * percent_x;

          // then the Y coordinates
          min = -4000;
          max = 4000;

          output.Y = min + (max - min) * percent_y;
        }
        else {
          // first the X coordinates
          min = -300;
          max = 300;

          output.X = min + (max - min) * percent_x;

          // then the Y coordinates
          min = -300;
          max = 300;

          output.Y = min + (max - min) * percent_y;
        }

        break;
    }

    return output;
  }

  // return the maximum progress the bounty will have for this seed. Each progress
  // level is a group of creatures.
  public function getNumberOfGroupsForSeed(seed: int): int {
    var min: int;
    var max: int;

    min = 3;
    // for every 20 levels bounties have a chance to get 1 more group
    max = 2 + (int)(this.getDifficultyForSeed(seed) * 0.05) + min;

    NLOG("getNumberOfGroupsForSeed(" + seed + ") - " + RandNoiseF(seed, max, min) + " " + max);

    // a difficulty 0 seed has maximum 5 monster groups in it
    // the difficulty seed step divided by 100 means that a difficulty 100 seed
    // will double the amount of creatures.
    return (int)(RandNoiseF(seed, max, min));
  }

  public function increaseBountyLevel() {
    this.master
      .storages
      .bounty
      .bounty_level += 1;

    this.master
      .storages
      .bounty
      .save();
  }
}