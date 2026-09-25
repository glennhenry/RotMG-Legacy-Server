package kabam.rotmg.external.service
{
   import com.company.util.MoreObjectUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.model.GameModel;
   
   public class RequestPlayerCreditsTask extends BaseTask
   {
      
      private static const REQUEST:String = "account/getCredits";
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var gameModel:GameModel;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      private var retryTimes:Array = [2,5,15];
      
      private var timer:Timer = new Timer(1000);
      
      private var retryCount:int = 0;
      
      public function RequestPlayerCreditsTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.timer.addEventListener(TimerEvent.TIMER,this.handleTimer);
         this.timer.start();
      }
      
      private function handleTimer(param1:TimerEvent) : void
      {
         --this.retryTimes[this.retryCount];
         if(this.retryTimes[this.retryCount] <= 0)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.handleTimer);
            this.makeRequest();
            ++this.retryCount;
            this.timer.stop();
         }
      }
      
      private function makeRequest() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest(REQUEST,this.makeRequestObject());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         var _loc4_:String = null;
         var _loc3_:Boolean = false;
         if(param1)
         {
            _loc4_ = XML(param2).toString();
            if(_loc4_ != "" && _loc4_.search("Error") != -1)
            {
               this.setCredits(int(_loc4_));
            }
         }
         else if(this.retryCount < this.retryTimes.length)
         {
            this.timer.addEventListener(TimerEvent.TIMER,this.handleTimer);
            this.timer.start();
            _loc3_ = true;
         }
         !_loc3_ && completeTask(param1,param2);
      }
      
      private function setCredits(param1:int) : void
      {
         if(param1 >= 0)
         {
            if(this.gameModel != null && this.gameModel.player != null && param1 != this.gameModel.player.credits_)
            {
               this.gameModel.player.credits_ = param1;
            }
            else if(this.playerModel != null && this.playerModel.getCredits() != param1)
            {
               this.playerModel.setCredits(param1);
            }
         }
      }
      
      private function makeRequestObject() : Object
      {
         var _loc1_:Object = {};
         MoreObjectUtil.addToObject(_loc1_,this.account.getCredentials());
         return _loc1_;
      }
   }
}

