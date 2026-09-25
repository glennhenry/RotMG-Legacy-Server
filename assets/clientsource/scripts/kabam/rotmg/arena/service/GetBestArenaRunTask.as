package kabam.rotmg.arena.service
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.arena.model.BestArenaRunModel;
   
   public class GetBestArenaRunTask extends BaseTask
   {
      
      private static const REQUEST:String = "arena/getPersonalBest";
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var bestRunModel:BestArenaRunModel;
      
      public function GetBestArenaRunTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest(REQUEST,this.makeRequestObject());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         param1 && this.updateBestRun(param2);
         completeTask(param1,param2);
      }
      
      private function updateBestRun(param1:String) : void
      {
         var _loc2_:XML = XML(param1);
         this.bestRunModel.entry.runtime = _loc2_.Record.Time;
         this.bestRunModel.entry.currentWave = _loc2_.Record.WaveNumber;
      }
      
      private function makeRequestObject() : Object
      {
         return this.account.getCredentials();
      }
   }
}

