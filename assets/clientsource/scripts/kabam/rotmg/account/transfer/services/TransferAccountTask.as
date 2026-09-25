package kabam.rotmg.account.transfer.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.MigrateAccountTask;
   import kabam.rotmg.account.transfer.model.TransferAccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.application.model.PlatformModel;
   import kabam.rotmg.application.model.PlatformType;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class TransferAccountTask extends BaseTask implements MigrateAccountTask
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var transferData:TransferAccountData;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function TransferAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/kabam/link",this.makeDataPacket());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         param1 && this.onLinkDone(param2);
         completeTask(param1,param2);
      }
      
      private function makeDataPacket() : Object
      {
         var _loc1_:Object = {};
         _loc1_.kabamemail = this.transferData.currentEmail;
         _loc1_.kabampassword = this.transferData.currentPassword;
         _loc1_.email = this.transferData.newEmail;
         _loc1_.password = this.transferData.newPassword;
         return _loc1_;
      }
      
      private function onLinkDone(param1:String) : void
      {
         var _loc3_:XML = null;
         var _loc2_:PlatformModel = StaticInjectorContext.getInjector().getInstance(PlatformModel);
         if(_loc2_.getPlatform() == PlatformType.WEB)
         {
            this.account.updateUser(this.transferData.newEmail,this.transferData.newPassword);
         }
         else
         {
            _loc3_ = new XML(param1);
            this.account.updateUser(_loc3_.GUID,_loc3_.Secret);
            this.account.setPlatformToken(_loc3_.PlatformToken);
         }
      }
   }
}

