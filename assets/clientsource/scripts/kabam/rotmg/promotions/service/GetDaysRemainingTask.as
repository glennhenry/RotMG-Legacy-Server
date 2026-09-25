package kabam.rotmg.promotions.service
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   
   public class GetDaysRemainingTask extends BaseTask
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:BeginnersPackageModel;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function GetDaysRemainingTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/getBeginnerPackageTimeLeft",this.account.getCredentials());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         this.onDaysRemainingResponse(param2);
      }
      
      private function onDaysRemainingResponse(param1:String) : void
      {
         var _loc2_:int = int(new XML(param1)[0]);
         this.model.setBeginnersOfferSecondsLeft(_loc2_);
         completeTask(_loc2_ > 0);
      }
   }
}

