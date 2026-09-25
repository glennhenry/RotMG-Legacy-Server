package kabam.rotmg.arena.service
{
   import com.company.util.MoreObjectUtil;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.arena.control.ReloadLeaderboard;
   import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
   import kabam.rotmg.arena.model.ArenaLeaderboardFilter;
   
   public class GetArenaLeaderboardTask extends BaseTask
   {
      
      private static const REQUEST:String = "arena/getRecords";
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var factory:ArenaLeaderboardFactory;
      
      [Inject]
      public var reloadLeaderboard:ReloadLeaderboard;
      
      public var filter:ArenaLeaderboardFilter;
      
      public function GetArenaLeaderboardTask()
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
         param1 && this.updateLeaderboard(param2);
         completeTask(param1,param2);
      }
      
      private function updateLeaderboard(param1:String) : void
      {
         var _loc2_:Vector.<ArenaLeaderboardEntry> = this.factory.makeEntries(XML(param1).Record);
         this.filter.setEntries(_loc2_);
         this.reloadLeaderboard.dispatch();
      }
      
      private function makeRequestObject() : Object
      {
         var _loc1_:Object = {"type":this.filter.getKey()};
         MoreObjectUtil.addToObject(_loc1_,this.account.getCredentials());
         return _loc1_;
      }
   }
}

