package kabam.rotmg.account.web.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.ChangePasswordTask;
   import kabam.rotmg.account.web.model.ChangePasswordData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class WebChangePasswordTask extends BaseTask implements ChangePasswordTask
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var data:ChangePasswordData;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function WebChangePasswordTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/changePassword",this.makeDataPacket());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         param1 && this.onChangeDone();
         completeTask(param1,param2);
      }
      
      private function makeDataPacket() : Object
      {
         var _loc1_:Object = {};
         _loc1_.guid = this.account.getUserId();
         _loc1_.password = this.data.currentPassword;
         _loc1_.newPassword = this.data.newPassword;
         return _loc1_;
      }
      
      private function onChangeDone() : void
      {
         this.account.updateUser(this.account.getUserId(),this.data.newPassword);
         completeTask(true);
      }
   }
}

