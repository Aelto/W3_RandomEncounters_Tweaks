
statemachine class RER_EventsManager extends CEntity {

  //#region listeners
  public var listeners: array<RER_EventsListener>;
  
  public function addListener(listener: RER_EventsListener) {
    this.listeners.PushBack(listener);

    listener.onReady(this.master);
  }
  //#endregion listeners

  public var master: CRandomEncounters;

  public function init(master: CRandomEncounters) {
    this.master = master;

    this.addListener(new RER_ListenerFightNoise in this);
    this.addListener(new RER_ListenerBloodNecrophages in this);
    this.addListener(new RER_ListenerFillCreaturesGroup in this);
    this.addListener(new RER_ListenerBodiesNecrophages in this);
    this.addListener(new RER_ListenerEntersSwamp in this);
  }

  public var delay: float;
  public var delta: float;
  

  public function start() {
    LogChannel('modRandomEncounters', "RER_EventsManager - start()");

    this.delay = this.master.settings.event_system_interval; // TODO: use a slider in the menu
    this.delta = 1 / this.delay;

    // only start the system if the delay is above 0
    if (this.delay > 0) {
      this.GotoState('Starting');
    }
  }
}
