package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.LoginTask;
   import kabam.rotmg.account.kongregate.view.KongregateApi;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class KongregateLoginTask extends BaseTask implements LoginTask
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var api:KongregateApi;
      
      [Inject]
      public var local:KongregateSharedObject;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function KongregateLoginTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kongregate/getcredentials",this.api.getAuthentication());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         param1 && this.onGetCredentialsDone(param2);
         completeTask(param1,param2);
      }
      
      private function onGetCredentialsDone(param1:String) : void
      {
         var _loc2_:XML = new XML(param1);
         this.account.updateUser(_loc2_.GUID,_loc2_.Secret);
         this.account.setPlatformToken(_loc2_.PlatformToken);
         completeTask(true);
      }
   }
}

