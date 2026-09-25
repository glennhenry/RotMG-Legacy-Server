package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.RelayLoginTask;
   import kabam.rotmg.account.kongregate.signals.KongregateAlreadyRegisteredSignal;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class KongregateRelayAPILoginTask extends BaseTask implements RelayLoginTask
   {
      
      public static const ALREADY_REGISTERED:String = "Kongregate account already registered";
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var api:KongregateApi;
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var alreadyRegistered:KongregateAlreadyRegisteredSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function KongregateRelayAPILoginTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kongregate/internalRegister",this.makeDataPacket());
      }
      
      private function makeDataPacket() : Object
      {
         var _loc1_:Object = this.api.getAuthentication();
         _loc1_.guid = this.account.getUserId();
         return _loc1_;
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onInternalRegisterDone(param2);
         }
         else if(param2 == ALREADY_REGISTERED)
         {
            this.alreadyRegistered.dispatch(this.data);
         }
         completeTask(param1,param2);
      }
      
      private function onInternalRegisterDone(param1:String) : void
      {
         var _loc2_:XML = new XML(param1);
         this.account.updateUser(_loc2_.GUID,_loc2_.Secret);
         this.account.setPlatformToken(_loc2_.PlatformToken);
      }
   }
}

