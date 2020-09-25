
// When the player is hurt (not full life) necrophages ambush can appear around him
class RER_ListenerBloodNecrophages extends RER_EventsListener {
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var trigger_chance: float;

  private var already_spawned_this_combat: bool;


  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERadvancedEvents', 'eventBloodNecrophages')
    );
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float): bool {
    var type: CreatureType;
    var is_in_combat: bool;
    var health_missing_perc: float;

    is_in_combat = thePlayer.IsInCombat();

    // to avoid triggering more than one event per fight
    if (is_in_combat && (was_spawn_already_triggered || this.already_spawned_this_combat)) {
      this.already_spawned_this_combat = true;

      return false;
    }

    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;

      return false;
    }
    
    this.already_spawned_this_combat = false;

    // this will be used to scale the % chances based on the missing health
    // the lower the health the higher the chances.
    health_missing_perc = 1 - thePlayer.GetHealthPercents();

    if (RandRangeF(100) < this.trigger_chance * delta * health_missing_perc) {
      type = this.getRandomNecrophageType(master);
      createRandomCreatureAmbush(master, type);

      // so that we don't spawn an ambush too frequently
      this.time_before_other_spawn += master.events_manager.internal_cooldown;
      
      LogChannel('modRandomEncounters', "RER_ListenerBloodNecrophages - spawn triggered type = " + type);

      return true;
    }

    return false;
  }

  private latent function getRandomNecrophageType(master: CRandomEncounters): CreatureType {
    var spawn_roller: SpawnRoller;
    var creatures_preferences: RER_CreaturePreferences;
    var i: int;
    var can_spawn_creature: bool;
    var manager : CWitcherJournalManager;

    spawn_roller = new SpawnRoller in this;
    spawn_roller.fill_arrays();

    creatures_preferences = new RER_CreaturePreferences in this;
    creatures_preferences
      .setIsNight(theGame.envMgr.IsNight())
      .setExternalFactorsCoefficient(master.settings.external_factors_coefficient)
      .setIsNearWater(master.rExtra.IsPlayerNearWater())
      .setIsInForest(master.rExtra.IsPlayerInForest())
      .setIsInSwamp(master.rExtra.IsPlayerInSwamp())
      .setChancesDay(master.settings.creatures_chances_day)
      .setChancesNight(master.settings.creatures_chances_night);

    creatures_preferences
      .reset()
      
      .setCreatureType(CreatureGHOUL)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureALGHOUL)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureDROWNER)
      .addOnlyBiome(BiomeSwamp)
      .addOnlyBiome(BiomeWater)
      .addLikedBiome(BiomeSwamp)
      .addLikedBiome(BiomeWater)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureDROWNERDLC)
      .addOnlyBiome(BiomeSwamp)
      .addOnlyBiome(BiomeWater)
      .addLikedBiome(BiomeSwamp)
      .addLikedBiome(BiomeWater)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureROTFIEND)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureWEREWOLF)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureEKIMMARA)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureKATAKAN)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureHAG)
      .addOnlyBiome(BiomeSwamp)
      .addOnlyBiome(BiomeWater)
      .addLikedBiome(BiomeSwamp)
      .addLikedBiome(BiomeWater)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureFOGLET)
      .addOnlyBiome(BiomeSwamp)
      .addOnlyBiome(BiomeWater)
      .addLikedBiome(BiomeSwamp)
      .addLikedBiome(BiomeWater)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureBRUXA)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureFLEDER)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureGARKAIN)
      .fillSpawnRoller(spawn_roller)

      .setCreatureType(CreatureDETLAFF)
      .fillSpawnRoller(spawn_roller);

    // https://github.com/Aelto/W3_RandomEncounters_Tweaks/issues/14
    // when a creature is set to NO in the city spawn menu, 
    // we remove it from the spawning pool.
    if (master.rExtra.isPlayerInSettlement()) {
      LogChannel('modRandomEncounters', "player in settlement, removing city spawns");

      for (i = 0; i < CreatureMAX; i += 1) {
        if (!master.settings.creatures_city_spawns[i]) {
          spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    // when the option "Only known bestiary creatures" is ON
    // we remove every unknown creatures from the spawning pool
    if (master.settings.only_known_bestiary_creatures) {
      manager = theGame.GetJournalManager();

      for (i = 0; i < CreatureMAX; i += 1) {
        can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(master.resources.creatures_resources[i], manager);
        
        if (!can_spawn_creature) {
          spawn_roller.setCreatureCounter(i, 0);
        }
      }
    }

    return spawn_roller.rollCreatures();
  }
}