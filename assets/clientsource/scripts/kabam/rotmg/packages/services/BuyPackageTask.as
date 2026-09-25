package kabam.rotmg.packages.services
{
   import com.company.assembleegameclient.map.QueueStatusTextSignal;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.packages.control.BuyPackageSuccessfulSignal;
   import kabam.rotmg.packages.model.PackageInfo;
   import kabam.rotmg.text.model.TextKey;
   
   public class BuyPackageTask extends BaseTask
   {
      
      private static const ERROR_MESSAGES_THAT_REFRESH:Array = ["Package is not Available","Package is not Available Right Now","Invalid PackageId"];
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var getPackageTask:GetPackagesTask;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var queueStatusText:QueueStatusTextSignal;
      
      [Inject]
      public var packageInfo:PackageInfo;
      
      [Inject]
      public var buyPackageSuccessful:BuyPackageSuccessfulSignal;
      
      public function BuyPackageTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var _loc1_:Object = this.account.getCredentials();
         _loc1_.packageId = this.packageInfo.packageID;
         this.playerModel.changeCredits(-this.packageInfo.price);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/purchasePackage",_loc1_);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         var _loc3_:XML = new XML(param2);
         if(param1)
         {
            this.completePurchase(_loc3_);
         }
         else
         {
            this.abandonPurchase(_loc3_);
         }
         completeTask(true,param2);
      }
      
      private function completePurchase(param1:XML) : void
      {
         if(this.packageInfo.quantity != PackageInfo.INFINITE)
         {
            --this.packageInfo.quantity;
         }
         ++this.packageInfo.numPurchased;
         this.queueStatusText.dispatch(TextKey.BUYPACKAGETASK_NEWGIFTS,11495650);
         this.buyPackageSuccessful.dispatch();
         if(this.packageInfo.quantity <= 0)
         {
            this.getPackageTask.start();
         }
      }
      
      private function abandonPurchase(param1:XML) : void
      {
         this.playerModel.changeCredits(this.packageInfo.price);
         this.reportFailureAndRefreshPackages(param1[0]);
      }
      
      private function reportFailureAndRefreshPackages(param1:String) : void
      {
         this.queueStatusText.dispatch(param1,16744576);
         if(ERROR_MESSAGES_THAT_REFRESH.indexOf(param1) != -1)
         {
            this.getPackageTask.start();
         }
      }
   }
}

