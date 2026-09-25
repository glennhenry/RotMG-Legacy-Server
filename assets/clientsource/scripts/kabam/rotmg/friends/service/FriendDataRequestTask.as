package kabam.rotmg.friends.service
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   
   public class FriendDataRequestTask extends BaseTask
   {
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      public var requestURL:String;
      
      public var xml:XML;
      
      public function FriendDataRequestTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(8);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest(this.requestURL,this.account.getCredentials());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.xml = new XML(param2);
            completeTask(true);
         }
         else
         {
            completeTask(false,param2);
         }
      }
   }
}

