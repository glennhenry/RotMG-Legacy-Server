package kabam.rotmg.account.web.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.SendConfirmEmailAddressTask;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.service.TrackingData;
   import kabam.rotmg.core.signals.TrackEventSignal;
   
   public class WebSendVerificationEmailTask extends BaseTask implements SendConfirmEmailAddressTask
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var track:TrackEventSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function WebSendVerificationEmailTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/sendVerifyEmail",this.account.getCredentials());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onSent();
         }
         else
         {
            this.onError(param2);
         }
      }
      
      private function onSent() : void
      {
         this.trackEmailSent();
         completeTask(true);
      }
      
      private function trackEmailSent() : void
      {
         var _loc1_:TrackingData = new TrackingData();
         _loc1_.category = "account";
         _loc1_.action = "verifyEmailSent";
         this.track.dispatch(_loc1_);
      }
      
      private function onError(param1:String) : void
      {
         this.account.clear();
         completeTask(false);
      }
   }
}

