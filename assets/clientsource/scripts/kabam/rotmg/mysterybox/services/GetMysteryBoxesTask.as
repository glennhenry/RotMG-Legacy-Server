package kabam.rotmg.mysterybox.services
{
   import com.company.assembleegameclient.util.TimeUtil;
   import flash.utils.getTimer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.application.DynamicSettings;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.fortune.model.FortuneInfo;
   import kabam.rotmg.fortune.services.FortuneModel;
   import kabam.rotmg.language.model.LanguageModel;
   import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
   import robotlegs.bender.framework.api.ILogger;
   
   public class GetMysteryBoxesTask extends BaseTask
   {
      
      private static const TEN_MINUTES:int = 600;
      
      private static var version:String = "0";
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var mysteryBoxModel:MysteryBoxModel;
      
      [Inject]
      public var fortuneModel:FortuneModel;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var languageModel:LanguageModel;
      
      [Inject]
      public var openDialogSignal:OpenDialogSignal;
      
      public var lastRan:uint = 0;
      
      public function GetMysteryBoxesTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Object = null;
         if(DynamicSettings.settingExists("MysteryBoxRefresh"))
         {
            _loc1_ = DynamicSettings.getSettingValue("MysteryBoxRefresh");
         }
         else
         {
            _loc1_ = TEN_MINUTES;
         }
         if(this.lastRan == 0 || this.lastRan + _loc1_ < getTimer() / 1000)
         {
            this.lastRan = getTimer() / 1000;
            completeTask(true);
            _loc2_ = this.account.getCredentials();
            _loc2_.language = this.languageModel.getLanguage();
            _loc2_.version = version;
            this.client.sendRequest("/mysterybox/getBoxes",_loc2_);
            this.client.complete.addOnce(this.onComplete);
         }
         else
         {
            completeTask(true);
            reset();
         }
      }
      
      public function clearLastRanBlock() : void
      {
         this.lastRan = 0;
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         reset();
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
         var _loc2_:XMLList = null;
         var _loc3_:XMLList = null;
         if(this.hasNoBoxes(param1))
         {
            if(this.mysteryBoxModel.isInitialized())
            {
               return;
            }
            this.mysteryBoxModel.setInitialized(false);
         }
         else
         {
            version = XML(param1).attribute("version").toString();
            _loc2_ = XML(param1).child("MysteryBox");
            this.parse(_loc2_);
            _loc3_ = XML(param1).child("FortuneGame");
            if(_loc3_.length() > 0)
            {
               this.parseFortune(_loc3_);
            }
         }
         completeTask(true);
      }
      
      private function hasNoBoxes(param1:*) : Boolean
      {
         var _loc2_:XMLList = XML(param1).children();
         return _loc2_.length() == 0;
      }
      
      private function parseFortune(param1:XMLList) : void
      {
         var _loc2_:FortuneInfo = new FortuneInfo();
         _loc2_.id = param1.attribute("id").toString();
         _loc2_.title = param1.attribute("title").toString();
         _loc2_.weight = param1.attribute("weight").toString();
         _loc2_.description = param1.Description.toString();
         _loc2_.contents = param1.Contents.toString();
         _loc2_.priceFirstInGold = param1.Price.attribute("firstInGold").toString();
         _loc2_.priceFirstInToken = param1.Price.attribute("firstInToken").toString();
         _loc2_.priceSecondInGold = param1.Price.attribute("secondInGold").toString();
         _loc2_.iconImageUrl = param1.Icon.toString();
         _loc2_.infoImageUrl = param1.Image.toString();
         _loc2_.startTime = TimeUtil.parseUTCDate(param1.StartTime.toString());
         _loc2_.endTime = TimeUtil.parseUTCDate(param1.EndTime.toString());
         _loc2_.parseContents();
         this.fortuneModel.setFortune(_loc2_);
      }
      
      private function parse(param1:XMLList) : void
      {
         var _loc4_:XML = null;
         var _loc5_:MysteryBoxInfo = null;
         var _loc2_:Array = [];
         var _loc3_:Boolean = false;
         for each(_loc4_ in param1)
         {
            _loc5_ = new MysteryBoxInfo();
            _loc5_.id = _loc4_.attribute("id").toString();
            _loc5_.title = _loc4_.attribute("title").toString();
            _loc5_.weight = _loc4_.attribute("weight").toString();
            _loc5_.description = _loc4_.Description.toString();
            _loc5_.contents = _loc4_.Contents.toString();
            _loc5_.priceAmount = _loc4_.Price.attribute("amount").toString();
            _loc5_.priceCurrency = _loc4_.Price.attribute("currency").toString();
            if(_loc4_.hasOwnProperty("Sale"))
            {
               _loc5_.saleAmount = _loc4_.Sale.attribute("price").toString();
               _loc5_.saleCurrency = _loc4_.Sale.attribute("currency").toString();
               _loc5_.saleEnd = TimeUtil.parseUTCDate(_loc4_.Sale.End.toString());
            }
            _loc5_.iconImageUrl = _loc4_.Icon.toString();
            _loc5_.infoImageUrl = _loc4_.Image.toString();
            _loc5_.startTime = TimeUtil.parseUTCDate(_loc4_.StartTime.toString());
            _loc5_.parseContents();
            if(!_loc3_ && (_loc5_.isNew() || _loc5_.isOnSale()))
            {
               _loc3_ = true;
            }
            _loc2_.push(_loc5_);
         }
         this.mysteryBoxModel.setMysetryBoxes(_loc2_);
         this.mysteryBoxModel.isNew = _loc3_;
      }
   }
}

