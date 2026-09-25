package kabam.rotmg.arena.control
{
   import kabam.rotmg.arena.model.CurrentArenaRunModel;
   import robotlegs.bender.bundles.mvcs.Command;
   
   public class ClearCurrentRunCommand extends Command
   {
      
      [Inject]
      public var currentRunModel:CurrentArenaRunModel;
      
      public function ClearCurrentRunCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         this.currentRunModel.clear();
      }
   }
}

