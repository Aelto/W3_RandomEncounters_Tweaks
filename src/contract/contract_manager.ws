
statemachine class RER_contractManager extends CEntity {
  var master: CRandomEncounters;

  function init(_master: CRandomEncounters) {
    this.master = _master;

    this.GotoState('Waiting');
  }

  function pickedContractNoticeFromNoticeboard() {
    this.GotoState('Noticeboard');
  }
}