package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.RegisterAccountTask;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.service.TrackingData;
   import kabam.rotmg.core.signals.TrackEventSignal;
   
   public class KongregateRegisterAccountTask extends BaseTask implements RegisterAccountTask
   {
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var api:KongregateApi;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var track:TrackEventSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function KongregateRegisterAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kongregate/register",this.makeDataPacket());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         param1 && this.onInternalRegisterDone(param2);
         completeTask(param1,param2);
      }
      
      private function makeDataPacket() : Object
      {
         var _loc1_:Object = this.api.getAuthentication();
         _loc1_.newGUID = this.data.username;
         _loc1_.newPassword = this.data.password;
         _loc1_.entrytag = this.account.getEntryTag();
         return _loc1_;
      }
      
      private function onInternalRegisterDone(param1:String) : void
      {
         this.updateAccount(param1);
         this.trackAccountRegistration();
      }
      
      private function trackAccountRegistration() : void
      {
         var _loc1_:TrackingData = new TrackingData();
         _loc1_.category = "kongregateAccount";
         _loc1_.action = "accountRegistered";
         this.track.dispatch(_loc1_);
      }
      
      private function updateAccount(param1:String) : void
      {
         var _loc2_:XML = new XML(param1);
         this.account.updateUser(_loc2_.GUID,_loc2_.Secret);
         this.account.setPlatformToken(_loc2_.PlatformToken);
      }
   }
}

