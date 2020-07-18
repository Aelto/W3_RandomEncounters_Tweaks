
latent function spawnEntities(entity_template: CEntityTemplate, initial_position: Vector, optional quantity: int, optional density: float): array<CEntity> {
  var ent: CEntity;
  var player, pos_fin, normal: Vector;
  var rot: EulerAngles;
  var i, sign: int;
  var s, r, x, y: float;
  var createEntityHelper: CCreateEntityHelper;
  var created_entities: array<CEntity>;
  
  quantity = Max(quantity, 1);

  if (density == 0) {
    density = 0.2;
  }

  LogChannel('modRandomEncounters', "spawning " + quantity + " entities");

  rot = thePlayer.GetWorldRotation();  

  //const values used in the loop
  pos_fin.Z = initial_position.Z;
  s = quantity / density; // maintain a constant density of 0.2 unit per m2
  r = SqrtF(s/Pi());

  createEntityHelper = new CCreateEntityHelper;
  // createEntityHelper.SetPostAttachedCallback(this, 'onEntitySpawned');

  for (i = 0; i < quantity; i += 1) {
    x = RandF() * r;        // add random value within range to X
    y = RandF() * (r - x);  // add random value to Y so that the point is within the disk

    if(RandRange(2))        // randomly select the sign for misplacement
      sign = 1;
    else
      sign = -1;
      
    pos_fin.X = initial_position.X + sign * x;  //final X pos
    
    if(RandRange(2))        // randomly select the sign for misplacement
      sign = 1;
    else
      sign = -1;
      
    pos_fin.Y = initial_position.Y + sign * y;  //final Y pos

    theGame.GetWorld().StaticTrace( pos_fin + Vector(0,0,3), pos_fin - Vector(0,0,3), pos_fin, normal);

    createEntityHelper.Reset();
    theGame.CreateEntityAsync(createEntityHelper, entity_template, pos_fin, rot, true, false, false, PM_DontPersist);

    LogChannel('modRandomEncounters', "spawning entity at " + pos_fin.X + " " + pos_fin.Y + " " + pos_fin.Z);

    while(createEntityHelper.IsCreating()) {            
      SleepOneFrame();
    }

    created_entities.PushBack(createEntityHelper.GetCreatedEntity());
  }

  return created_entities;
}