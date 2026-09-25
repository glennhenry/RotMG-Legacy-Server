package kabam.rotmg.account.web.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.RegisterAccountTask;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class WebRegisterAccountTask extends BaseTask implements RegisterAccountTask
   {
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function WebRegisterAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/register",this.makeDataPacket());
      }
      
      private function makeDataPacket() : Object
      {
         var _loc1_:Object = {};
         _loc1_.guid = this.account.getUserId();
         _loc1_.newGUID = this.data.username;
         _loc1_.newPassword = this.data.password;
         _loc1_.entrytag = this.account.getEntryTag();
         _loc1_.isAgeVerified = 1;
         return _loc1_;
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         param1 && this.onRegisterDone();
         completeTask(param1,param2);
      }
      
      private function onRegisterDone() : void
      {
         this.model.setIsAgeVerified(true);
         this.account.updateUser(this.data.username,this.data.password);
      }
   }
}

