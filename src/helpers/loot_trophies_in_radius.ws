
function lootTrophiesInRadius(): bool {
  var entities : array<CGameplayEntity>;
  var items_guids: array<SItemUniqueId>;
  var looted_a_trophy: bool;
  var i: int;
  var guid_used_for_notification: SItemUniqueId;

  looted_a_trophy = false;

  LogChannel('modRandomEncounters', "searching lootbag nearby");
  FindGameplayEntitiesInRange( entities, thePlayer, 25, 30, , FLAG_ExcludePlayer/*,, 'W3Container'*/ );

  for (i = 0; i < entities.Size(); i += 1) {
    if (((W3Container)entities[i])) {
      LogChannel('modRandomEncounters', "lootbag - giving all RER_Trophy to player");
      items_guids = ((W3Container)entities[i]).GetInventory().GetItemsByTag('RER_Trophy');

      // set `looted_a_trophy` if a trophy was found
      looted_a_trophy = looted_a_trophy || items_guids.Size() > 0;

      if (items_guids.Size() > 0) {
        guid_used_for_notification = items_guids[0];
      }
      
      LogChannel('modRandomEncounters', "lootbag - found " + items_guids.Size() + " trophies");
      ((W3Container)entities[i]).GetInventory()
        .GiveItemsTo(thePlayer.GetInventory(), items_guids);
    }
  }

  return looted_a_trophy;
}
