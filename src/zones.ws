//--- RandomEncounters ---
// Made by Erxv
enum EREZone {
  REZ_UNDEF   = 0,
  REZ_NOSPAWN = 1,
  REZ_SWAMP   = 2,
  REZ_CITY    = 3,
}

class CModRExtra extends CRandomEncounters { 
  public function getCustomZone(pos : Vector) : EREZone {
    var zone : EREZone;
    var currentArea : string;
     
    zone = REZ_UNDEF;
    currentArea = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());
     
    if (currentArea == "novigrad")
    {
      if ( (pos.X < 730 && pos.X > 290)  && (pos.Y < 2330 && pos.Y > 1630))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 730 && pos.X > 450)  && (pos.Y < 1640 && pos.Y > 1530))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 930 && pos.X > 700)  && (pos.Y < 2080 && pos.Y > 1635))
      {
        //zone = "novigrad";
        zone = REZ_CITY;
      } 
      else if ( (pos.X < 1900 && pos.X > 1600)  && (pos.Y < 1200 && pos.Y > 700))
      {
        //zone = "oxenfurt";
        zone = REZ_CITY;
      }
      else if ( (pos.X < 315 && pos.X > 95)  && (pos.Y < 240 && pos.Y > 20))
      {
        //zone = "crows";
        zone = REZ_CITY;
      }
      else if ( (pos.X < 2350 && pos.X > 2200)  && (pos.Y < 2600 && pos.Y > 2450))
      {
        //zone = "HoS Wedding";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < 2255 && pos.X > 2135)  && (pos.Y < 2180 && pos.Y > 2010))
      {
        //zone = "HoS Creepy Mansion";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < 1550 && pos.X > 930)  && (pos.Y < 1320 && pos.Y > 950))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 1400 && pos.X > 940)  && (pos.Y < -460 && pos.Y > -720))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 1790 && pos.X > 1320)  && (pos.Y < -400 && pos.Y > -540))
      {
        zone = REZ_SWAMP;
      }
      else if ( (pos.X < 2150 && pos.X > 1750)  && (pos.Y < -490 && pos.Y > -1090))
      {
        zone = REZ_SWAMP;
      }
    }
    else if (currentArea == "skellige")
    {
      if ( (pos.X < 30 && pos.X > -290)  && (pos.Y < 790 && pos.Y > 470))
      {
        //zone = "trolde";
        zone = REZ_CITY;
      }
    }
    else if (currentArea == "bob")
    {
      if ( (pos.X < -292 && pos.X > -417)  && (pos.Y < -755 && pos.Y > -872))
      {
        //zone = "corvo";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < -414 && pos.X > -636)  && (pos.Y < -863 && pos.Y > -1088))
      {
        //zone = "tourney";
        zone = REZ_NOSPAWN;
      }
      else if ( (pos.X < -142 && pos.X > -871)  && (pos.Y < -1082 && pos.Y > -1637))
      {
        //zone = "city";
        zone = REZ_CITY;
      }
    } 
    else if (currentArea == "wyzima_castle" || currentArea == "island_of_mist" || currentArea == "spiral")
    {
      zone = REZ_NOSPAWN;
    } 
  
    return zone; 
  }

  public function getRandomHumanTypeByCurrentArea(): EHumanType {
    var choice: array<EHumanType>;
    var current_area: string;
    var i: int;

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    if (current_area == "prolog_village") {
      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_BANDIT);
      }
      
      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }
      
      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }
    }
    else if (current_area == "skellige") {
      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_SKELBANDIT);
      }
      
      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_SKELBANDIT2);
      }
  
      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_SKELPIRATE);
      }
    }
    else if (current_area == "kaer_morhen") {
      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_BANDIT);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }
    }
    else if (current_area == "novigrad" || current_area == "no_mans_land") {
      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_NOVBANDIT);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_PIRATE);
      }

      for (i=0; i<3; i+=1) {
        choice.PushBack(HT_BANDIT);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NILFGAARDIAN);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_WITCHHUNTER);
      }
    }
    else if (current_area == "bob") {
      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NOVBANDIT);
      }

      for (i=0; i<4; i+=1) {
        choice.PushBack(HT_BANDIT);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NILFGAARDIAN);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }
    }
    else {
      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NOVBANDIT);
      }

      for (i=0; i<4; i+=1) {
        choice.PushBack(HT_BANDIT);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_NILFGAARDIAN);
      }

      for (i=0; i<1; i+=1) {
        choice.PushBack(HT_CANNIBAL);
      }

      for (i=0; i<2; i+=1) {
        choice.PushBack(HT_RENEGADE);
      }
    }

    return choice[RandRange(choice.Size())];
  }

  public function getRandomGroupCreatureByCurrentArea(settings: RE_Settings): EGroundMonsterType {
    var currentArea : string;
    var choice : array<EGroundMonsterType>;

    var harpy_chance: int;
    var fogling_chance: int;
    var endrega_chance: int;
    var ghouls_chance: int;
    var alghouls_chance: int;
    var nekkers_chance: int;
    var drowners_chance: int;
    var rotfiends_chance: int;
    var wolves_chance: int;
    var wraiths_chance: int;
    var spiders_chance: int;
    var barghest_chance: int;
    var echinops_chance: int;
    var centipede_chance: int;
    var kikimore_chance: int;
    var wight_chance: int;
    var drownerDLC_chance: int;
    var skeleton_chance: int;

    var is_in_forest: bool;
    var is_near_water: bool;
    var is_in_swamp: bool;

    var i: int;
    var current_area: string;

    is_in_forest = this.IsPlayerInForest();
    is_near_water = this.IsPlayerNearWater();
    is_in_swamp = this.IsPlayerInSwamp();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());			

    if (theGame.envMgr.IsNight()) {
      harpy_chance = settings.isHarpyN;
      fogling_chance = settings.isFoglingN;
      endrega_chance = settings.isEndregaN;
      ghouls_chance = settings.isGhoulsN;
      alghouls_chance = settings.isAlghoulsN;
      nekkers_chance = settings.isNekkersN;
      drowners_chance = settings.isDrownersN;
      rotfiends_chance = settings.isRotfiendsN;
      wolves_chance = settings.isWolvesN;
      wraiths_chance = settings.isWraithsN;
      spiders_chance = settings.isSpidersN;

      barghest_chance = settings.isBarghestN;
      echinops_chance = settings.isEchinopsN;
      centipede_chance = settings.isCentipedeN;
      kikimore_chance = settings.isKikimoreN;
      wight_chance = settings.isWightN;
      drownerDLC_chance = settings.isDrownerDLCN;
      skeleton_chance = settings.isSkeletonN;
    }
    else {
      harpy_chance = settings.isHarpyD;
      fogling_chance = settings.isFoglingD;
      endrega_chance = settings.isEndregaD;
      ghouls_chance = settings.isGhoulsD;
      alghouls_chance = settings.isAlghoulsD;
      nekkers_chance = settings.isNekkersD;
      drowners_chance = settings.isDrownersD;
      rotfiends_chance = settings.isRotfiendsD;
      wolves_chance = settings.isWolvesD;
      wraiths_chance = settings.isWraithsD;
      spiders_chance = settings.isSpidersD;

      barghest_chance = settings.isBarghestD;
      echinops_chance = settings.isEchinopsD;
      centipede_chance = settings.isCentipedeD;
      kikimore_chance = settings.isKikimoreD;
      wight_chance = settings.isWightD;
      drownerDLC_chance = settings.isDrownerDLCD;
      skeleton_chance = settings.isSkeletonD;
    }

    if (current_area == "prolog_village") {
      if (is_near_water || is_in_swamp) {
        for (i=0; i<drowners_chance; i+=1) {
          choice.PushBack(GM_DROWNER);
        }

        for (i=0; i<drownerDLC_chance; i+=1)  {
          choice.PushBack(GM_DROWNERDLC);
        }
      }

      if (is_in_forest) {
        for (i=0; i<spiders_chance; i+=1) {
          choice.PushBack(GM_SPIDER);
        }
      }

      for (i=0; i<ghouls_chance; i+=1) {
        choice.PushBack(GM_GHOUL);
      }

      for (i=0; i<nekkers_chance; i+=1)  {
        choice.PushBack(GM_NEKKER);
      }

      for (i=0; i<wolves_chance; i+=1)   {
        choice.PushBack(GM_WOLF);
      }

      for (i=0; i<wraiths_chance; i+=1)  {
        choice.PushBack(GM_WRAITH);
      }

      for (i=0; i<wight_chance; i+=1)  {
        choice.PushBack(GM_WIGHT);
      }

      for (i=0; i<skeleton_chance; i+=1)  {
        choice.PushBack(GM_SKELETON);
      }
    }
    else {
      if (is_in_swamp) {
        for (i=0; i<fogling_chance; i+=1)  {
          choice.PushBack(GM_FOGLET);
        }
      }

      if (is_in_forest) {
        for (i=0; i<endrega_chance; i+=1)  {
          choice.PushBack(GM_ENDREGA);
        }

        for (i=0; i<spiders_chance; i+=1)  {
          choice.PushBack(GM_SPIDER);
        }
      }

      if (!is_in_forest && !is_in_swamp) {
        for (i=0; i<harpy_chance; i+=1)    {
          choice.PushBack(GM_HARPY);
        }
      }

      if (!is_near_water && !is_in_swamp) {
        for (i=0; i<centipede_chance; i+=1){
          choice.PushBack(GM_CENTIEDE);
        }
      }

      if (is_near_water) {
        for (i=0; i<drowners_chance; i+=1) {
          choice.PushBack(GM_DROWNER);
        }
      }

      if (!is_in_forest) {
        for (i=0; i<barghest_chance; i+=1) {
          choice.PushBack(GM_BARGHEST);
        }
      }

      for (i=0; i<ghouls_chance; i+=1)   {
        choice.PushBack(GM_GHOUL);
      }

      for (i=0; i<alghouls_chance; i+=1) {
        choice.PushBack(GM_ALGHOUL);
      }

      for (i=0; i<nekkers_chance; i+=1)  {
        choice.PushBack(GM_NEKKER);
      }

      for (i=0; i<rotfiends_chance; i+=1){
        choice.PushBack(GM_ROTFIEND);
      }

      for (i=0; i<wolves_chance; i+=1)   {
        choice.PushBack(GM_WOLF);
      }

      for (i=0; i<wraiths_chance; i+=1)  {
        choice.PushBack(GM_WRAITH);
      }

      for (i=0; i<echinops_chance; i+=1) {
        choice.PushBack(GM_ECHINOPS);
      }

      for (i=0; i<kikimore_chance; i+=1) {
        choice.PushBack(GM_KIKIMORE);
      }

      for (i=0; i<wight_chance; i+=1)  {
        choice.PushBack(GM_WIGHT);
      }

      for (i=0; i<drownerDLC_chance; i+=1)  {
        choice.PushBack(GM_DROWNERDLC);
      }

      for (i=0; i<skeleton_chance; i+=1)  {
        choice.PushBack(GM_SKELETON);
      }
    }

    return choice[RandRange(choice.Size())];
  }

  public function getRandomGroundCreatureByCurrentArea(settings: RE_Settings): EGroundMonsterType {
    var choice : array<EGroundMonsterType>;
    var i: int;
    var current_area: string;

    var leshens_chance: int;
    var werewolves_chance: int;
    var fiends_chance: int;
    var chorts_chance: int;
    var arachas_chance: int;
    var cyclops_chance: int;
    var ekimmara_chance: int;
    var katakan_chance: int;
    var bears_chance: int;
    var golems_chance: int;
    var elementals_chance: int;
    var nightWraiths_chance: int;
    var noonWraiths_chance: int;
    var troll_chance: int;
    var hags_chance: int;
    var bruxa_chance: int;
    var higherVamp_chance: int;
    var fleder_chance: int;
    var garkain_chance: int;
    var panther_chance: int;
    var sharley_chance: int;
    var giant_chance: int;
    var boar_chance: int;

    var is_in_forest: bool;
    var is_near_water: bool;
    var is_in_swamp: bool;

    is_in_forest = this.IsPlayerInForest();
    is_near_water = this.IsPlayerNearWater();
    is_in_swamp = this.IsPlayerInSwamp();

    current_area = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    if (theGame.envMgr.IsNight()) {
      leshens_chance = settings.isLeshensN;
      werewolves_chance = settings.isWerewolvesN;
      fiends_chance = settings.isFiendsN;
      chorts_chance = settings.isChortsN;
      arachas_chance = settings.isArachasN;
      cyclops_chance = settings.isCyclopsN;
      ekimmara_chance = settings.isEkimmaraN;
      katakan_chance = settings.isKatakanN;
      bears_chance = settings.isBearsN;
      golems_chance = settings.isGolemsN;
      elementals_chance = settings.isElementalsN;
      nightWraiths_chance = settings.isNightWraithsN;
      noonWraiths_chance = settings.isNoonWraithsN;
      troll_chance = settings.isTrollN;
      hags_chance = settings.isHagsN;

      bruxa_chance = settings.isBruxaN;
      higherVamp_chance = settings.isHigherVampN;
      fleder_chance = settings.isFlederN;
      garkain_chance = settings.isGarkainN;
      panther_chance = settings.isPantherN;
      sharley_chance = settings.isSharleyN;
      giant_chance = settings.isGiantN;
      boar_chance = settings.isBoarN;
    }
    else {
      leshens_chance = settings.isLeshensD;
      werewolves_chance = settings.isWerewolvesD;
      fiends_chance = settings.isFiendsD;
      chorts_chance = settings.isChortsD;
      arachas_chance = settings.isArachasD;
      cyclops_chance = settings.isCyclopsD;
      ekimmara_chance = settings.isEkimmaraD;
      katakan_chance = settings.isKatakanD;
      bears_chance = settings.isBearsD;
      golems_chance = settings.isGolemsD;
      elementals_chance = settings.isElementalsD;
      nightWraiths_chance = settings.isNightWraithsD;
      noonWraiths_chance = settings.isNoonWraithsD;
      troll_chance = settings.isTrollD;
      hags_chance = settings.isHagsD;

      bruxa_chance = settings.isBruxaD;
      higherVamp_chance = settings.isHigherVampD;
      fleder_chance = settings.isFlederD;
      garkain_chance = settings.isGarkainD;
      panther_chance = settings.isPantherD;
      sharley_chance = settings.isSharleyD;
      giant_chance = settings.isGiantD;
      boar_chance = settings.isBoarD;
    }
    
    if (current_area == "prolog_village") {
      if (!is_in_swamp) {
        for (i=0; i<werewolves_chance; i+=1) {
          choice.PushBack(GM_WEREWOLF);
        }
      }

      if (!is_in_swamp && !is_in_forest && theGame.envMgr.IsNight()) {
        for (i=0; i<nightWraiths_chance; i+=1){
          choice.PushBack(GM_NIGHTWRAITH);
        }
      }

      if (!is_in_forest && !is_in_swamp && !theGame.envMgr.IsNight()) {
        for (i=0; i<noonWraiths_chance; i+=1) {
          choice.PushBack(GM_NOONWRAITH);
        }
      }

      for (i=0; i<bears_chance; i+=1) {
        choice.PushBack(GM_BEAR);
      }

      for (i=0; i<bruxa_chance; i+=1) {
        choice.PushBack(GM_BRUXA);
      }

      for (i=0; i<higherVamp_chance; i+=1) {
        choice.PushBack(GM_DETLAFF);
      }

      for (i=0; i<garkain_chance; i+=1) {
        choice.PushBack(GM_GARKAIN);
      }

      for (i=0; i<fleder_chance; i+=1) {
        choice.PushBack(GM_FLEDER);
      }

      for (i=0; i<panther_chance; i+=1) {
        choice.PushBack(GM_PANTHER);
      }

      for (i=0; i<boar_chance; i+=1) {
        choice.PushBack(GM_BOAR);
      }
    }
    else {
      if (is_in_forest) {
        for (i=0; i<leshens_chance; i+=1) {
          choice.PushBack(GM_LESHEN);
        }

        for (i=0; i<arachas_chance; i+= 1) {
          choice.PushBack(GM_ARACHAS);
        }
      }

      if (!is_in_swamp) {
        for (i=0; i<werewolves_chance; i+=1) {
          choice.PushBack(GM_WEREWOLF);
        }

        for (i=0; i<elementals_chance; i+=1) {
          choice.PushBack(GM_ELEMENTAL);
        }
      }

      if (!is_in_forest && is_in_swamp && theGame.envMgr.IsNight()) {
        for (i=0; i<nightWraiths_chance; i+=1){
          choice.PushBack(GM_NIGHTWRAITH);
        }
      }

      if (!is_in_forest && !is_in_swamp) {
        for (i=0; i<noonWraiths_chance; i+=1) {
          choice.PushBack(GM_NOONWRAITH);
        }
      }

      for (i=0; i<chorts_chance; i+=1) {
        choice.PushBack(GM_CHORT);
      }

      for (i=0; i<fiends_chance; i+=1) {
        choice.PushBack(GM_FIEND);
      }

      for (i=0; i<bears_chance; i+=1) {
        choice.PushBack(GM_BEAR);
      }

      for (i=0; i<golems_chance; i+=1) {
        choice.PushBack(GM_GOLEM);
      }

      for (i=0; i<cyclops_chance; i+= 1) {
        choice.PushBack(GM_CYCLOPS);
      }

      for (i=0; i<troll_chance; i+=1) {
        choice.PushBack(GM_TROLL);
      }

      for (i=0; i<hags_chance; i+=1) {
        choice.PushBack(GM_HAG);
      }

      for (i=0; i<ekimmara_chance; i+=1) {
        choice.PushBack(GM_EKIMMARA);
      }

      for (i=0; i<katakan_chance; i+=1) {
        choice.PushBack(GM_KATAKAN);
      }

      for (i=0; i<bruxa_chance; i+=1) {
        choice.PushBack(GM_BRUXA);
      }

      for (i=0; i<higherVamp_chance; i+=1) {
        choice.PushBack(GM_DETLAFF);
      }

      for (i=0; i<garkain_chance; i+=1) {
        choice.PushBack(GM_GARKAIN);
      }

      for (i=0; i<fleder_chance; i+=1) {
        choice.PushBack(GM_FLEDER);
      }

      for (i=0; i<panther_chance; i+=1) {
        choice.PushBack(GM_PANTHER);
      }

      for (i=0; i<sharley_chance; i+=1) {
        choice.PushBack(GM_SHARLEY);
      }

      for (i=0; i<giant_chance; i+=1) {
        choice.PushBack(GM_GIANTDLC);
      }

      for (i=0; i<boar_chance; i+=1) {
        choice.PushBack(GM_BOAR);
      }
    }

    return choice[RandRange(choice.Size())];
  }

  public function IsPlayerNearWater() : bool {
    var i, j : int;
    var pos, newPos : Vector;
    var vectors : array<Vector>;
    var world : CWorld;
    var waterDepth : float;

    pos = thePlayer.GetWorldPosition();

    world = theGame.GetWorld();

    for (i = 2; i <= 50; i += 2) {
      vectors = VecSphere(10, i);

      for (j = 0; j < vectors.Size(); j += 1) {
        newPos = pos + vectors[j];
        FixZAxis(newPos);
        waterDepth = world.GetWaterDepth(newPos, true);

        if (waterDepth > 1.0f && waterDepth != 10000.0) {
          return true;
        }
      }
    }

    return false;
  }

  public function IsPlayerInSwamp() : bool {
    var i, j : int;
    var pos, newPos : Vector;
    var vectors : array<Vector>;
    var world : CWorld;
    var waterDepth : float;
    var wetTerrainQuantity : int;

    pos = thePlayer.GetWorldPosition();

    world = theGame.GetWorld();

    wetTerrainQuantity = 0;

    for (i = 2; i <= 50; i += 2) {
      vectors = VecSphere(10, i);
  
      for (j = 0; j < vectors.Size(); j += 1) {
        newPos = pos + vectors[j];
        FixZAxis(newPos);
        waterDepth = world.GetWaterDepth(newPos, true);

        if (waterDepth > 0 && waterDepth < 1.5f) {
          wetTerrainQuantity += 1;
        }
        else {
          wetTerrainQuantity -= 1;
        }
      }
    }

    return wetTerrainQuantity > -300;
  }

  public function IsPlayerInForest() : bool
  {
    var cg : array<name>;
    var i, j, k : int;
    var compassPos : array<Vector>;
    var angles : array<int>;
    var angle : int;
    var vectors : array<Vector>;
    var tracePosStart, tracePosEnd : Vector;
    var material : name;
    var component : CComponent;
    var outPos, normal : Vector;
    var angularQuantity, totalQuantity : int;
    var lastPos : Vector;
    var skip : bool;
    var skipIdx : int;

    cg.PushBack('Foliage');

    compassPos = VecSphere(90, 20);
    compassPos.Insert(0, thePlayer.GetWorldPosition());

    for (i = 1; i < compassPos.Size(); i += 1) {
      compassPos[i] = compassPos[0] + compassPos[i];
      FixZAxis(compassPos[i]);
      compassPos[i].Z += 10;
    }

    compassPos[0].Z += 10;

    angles.PushBack(0);
    angles.PushBack(90);
    angles.PushBack(180);
    angles.PushBack(270);

    totalQuantity = 0;

    skip = false;
    skipIdx = -1;

    for (i = 0; i < compassPos.Size(); i += 1) {
      for (j = 0; j < angles.Size(); j += 1) {
        angularQuantity = 0;
        angle = angles[j];
        vectors = VecArc(angle, angle+90, 5, 25);

        for (k = 0; k < vectors.Size(); k += 1) {
          tracePosStart = compassPos[i];
          tracePosEnd = tracePosStart;
          tracePosEnd.Z -= 10;
          tracePosEnd = tracePosEnd + vectors[k];
          FixZAxis(tracePosEnd);
          tracePosEnd.Z += 10;

          if (theGame.GetWorld().StaticTraceWithAdditionalInfo(tracePosStart, tracePosEnd, outPos, normal, material, component, cg)) {
            if (material == 'default' && !component) {
              if (VecDistanceSquared(lastPos, outPos) > 10) {
                lastPos = outPos;
                angularQuantity += 1;
                totalQuantity += 1;
              }
            }
          }
        }

        if (angularQuantity < 1) {
          if (i > 0 && (!skip || skipIdx == i)) {
            skip = true;
            skipIdx = i;
          }
          else {
            return false;
          }
        }
      }
    }

    return totalQuantity > 10;
  }
}


function FixZAxis(out pos : Vector) {
  var world : CWorld;
  var z : float;

  world = theGame.GetWorld();

  if (world.NavigationComputeZ(pos, pos.Z - 128, pos.Z + 128, z)) {
    pos.Z = z;
  }

  if (world.PhysicsCorrectZ(pos, z)) {
    pos.Z = z;
  }
}

function VecArc(angleStart : int, angleEnd : int, angleStep : int, radius : float) : array<Vector>
{
    var i : int;
	var angle : float;
    var v : Vector;
    var vectors: array<Vector>;

    for (i = angleStart; i < angleEnd; i += angleStep)
    {
        angle = Deg2Rad(i);
        v = Vector(radius * CosF(angle), radius * SinF(angle), 0.0, 1.0);
        vectors.PushBack(v);
    }

    return vectors;
}

function VecSphere(angleStep : int, radius : float) : array<Vector>
{
    var i : int;
	var angle : float;
    var v : Vector;
    var vectors: array<Vector>;

    for (i = 0; i < 360; i += angleStep)
    {
        angle = Deg2Rad(i);
        v = Vector(radius * CosF(angle), radius * SinF(angle), 0.0, 1.0);
        vectors.PushBack(v);
    }

    return vectors;
}