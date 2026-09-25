package kabam.rotmg.packages.services
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.language.model.LanguageModel;
   import kabam.rotmg.packages.model.PackageInfo;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetPackagesTask extends BaseTask
   {
      
      private static const HOUR:int = 1000 * 60 * 60;
      
      public var timer:Timer = new Timer(HOUR);
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var packageModel:PackageModel;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var languageModel:LanguageModel;
      
      public function GetPackagesTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var _loc1_:Object = this.account.getCredentials();
         _loc1_.language = this.languageModel.getLanguage();
         this.client.sendRequest("/package/getPackages",_loc1_);
         this.client.complete.addOnce(this.onComplete);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.handleOkay(param2);
         }
         else
         {
            this.logger.warn("GetPackageTask.onComplete: Request failed.");
            completeTask(false);
         }
      }
      
      private function handleOkay(param1:*) : void
      {
         var _loc2_:XML = null;
         if(this.hasNoPackage(param1))
         {
            this.logger.info("GetPackageTask.onComplete: No package available, retrying in 1 hour.");
            this.timer.addEventListener(TimerEvent.TIMER,this.timer_timerHandler);
            this.timer.start();
            this.packageModel.setPackages([]);
         }
         else
         {
            _loc2_ = XML(param1);
            this.parse(_loc2_);
         }
         completeTask(true);
      }
      
      private function hasNoPackage(param1:*) : Boolean
      {
         var _loc2_:XMLList = XML(param1).Packages;
         return _loc2_.length() == 0;
      }
      
      private function parse(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Date = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:PackageInfo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.Packages.Package)
         {
            _loc4_ = int(_loc3_.@id);
            _loc5_ = String(_loc3_.Name);
            _loc6_ = int(_loc3_.Price);
            _loc7_ = int(_loc3_.Quantity);
            _loc8_ = int(_loc3_.MaxPurchase);
            _loc9_ = int(_loc3_.Weight);
            _loc10_ = new Date(String(_loc3_.EndDate));
            _loc11_ = String(_loc3_.BgURL);
            _loc12_ = this.getNumPurchased(param1,_loc4_);
            _loc13_ = new PackageInfo();
            _loc13_.setData(_loc4_,_loc10_,_loc5_,_loc7_,_loc8_,_loc9_,_loc6_,_loc11_,_loc12_);
            _loc2_.push(_loc13_);
         }
         this.packageModel.setPackages(_loc2_);
      }
      
      private function getNumPurchased(param1:XML, param2:int) : int
      {
         var packageHistory:XMLList = null;
         var packagesXML:XML = param1;
         var packageID:int = param2;
         var numPurchased:int = 0;
         var history:XMLList = packagesXML.History;
         if(history)
         {
            packageHistory = history.Package.(@id == packageID);
            if(packageHistory)
            {
               numPurchased = int(packageHistory.Count);
            }
         }
         return numPurchased;
      }
      
      private function timer_timerHandler(param1:TimerEvent) : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.timer_timerHandler);
         this.timer.stop();
         this.startTask();
      }
   }
}

