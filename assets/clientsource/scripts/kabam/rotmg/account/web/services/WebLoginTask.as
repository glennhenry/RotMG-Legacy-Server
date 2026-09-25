package kabam.rotmg.account.web.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.LoginTask;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class WebLoginTask extends BaseTask implements LoginTask
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var client:AppEngineClient;
      
      public function WebLoginTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/verify",{
            "guid":this.data.username,
            "password":this.data.password
         });
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.updateUser(param2);
         }
         completeTask(param1,param2);
      }
      
      private function updateUser(param1:String) : void
      {
         this.account.updateUser(this.data.username,this.data.password);
      }
   }
}

