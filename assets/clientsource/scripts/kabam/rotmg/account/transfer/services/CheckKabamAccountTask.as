package kabam.rotmg.account.transfer.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.transfer.model.TransferAccountData;
   import kabam.rotmg.account.transfer.view.KabamLoginView;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class CheckKabamAccountTask extends BaseTask
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var data:TransferAccountData;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var view:KabamLoginView;
      
      public function CheckKabamAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kabam/verify",this.makeDataPacket());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(!param1)
         {
            this.view.setError(param2);
            this.view.enable();
         }
         else
         {
            this.onChangeDone();
         }
         completeTask(param1,param2);
      }
      
      private function makeDataPacket() : Object
      {
         var _loc1_:Object = {};
         _loc1_.kabamemail = this.data.currentEmail;
         _loc1_.kabampassword = this.data.currentPassword;
         return _loc1_;
      }
      
      private function onChangeDone() : void
      {
         this.account.updateUser(this.data.newEmail,this.data.newPassword);
         completeTask(true);
      }
   }
}

