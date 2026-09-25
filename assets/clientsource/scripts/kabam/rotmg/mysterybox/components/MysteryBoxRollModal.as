package kabam.rotmg.mysterybox.components
{
   import com.company.assembleegameclient.map.ParticleModalMap;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import com.company.assembleegameclient.ui.dialogs.NotEnoughFameDialog;
   import com.company.assembleegameclient.util.Currency;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Sine;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.assets.EmbeddedAssets;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.fortune.components.ItemWithTooltip;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
   import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.pets.view.dialogs.evolving.Spinner;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.view.NotEnoughGoldDialog;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import kabam.rotmg.util.components.UIAssetsHelper;
   import org.swiftsuspenders.Injector;
   
   public class MysteryBoxRollModal extends Sprite
   {
      
      public static var open:Boolean;
      
      public static const WIDTH:int = 415;
      
      public static const HEIGHT:int = 400;
      
      public static const TEXT_MARGIN:int = 20;
      
      private const ROLL_STATE:int = 1;
      
      private const IDLE_STATE:int = 0;
      
      private const iconSize:Number = 160;
      
      public var client:AppEngineClient;
      
      public var account:Account;
      
      public var parentSelectModal:MysteryBoxSelectModal;
      
      private var state:int;
      
      private var isShowReward:Boolean = false;
      
      private var rollCount:int = 0;
      
      private var rollTarget:int = 0;
      
      private var quantity_:int = 0;
      
      private var mbi:MysteryBoxInfo;
      
      private var spinners:Sprite = new Sprite();
      
      private var itemBitmaps:Vector.<Bitmap> = new Vector.<Bitmap>();
      
      private var rewardsArray:Vector.<ItemWithTooltip> = new Vector.<ItemWithTooltip>();
      
      private var closeButton:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(WIDTH);
      
      private var particleModalMap:ParticleModalMap;
      
      private const playAgainString:String = "MysteryBoxRollModal.playAgainString";
      
      private const playAgainXTimesString:String = "MysteryBoxRollModal.playAgainXTimesString";
      
      private const youWonString:String = "MysteryBoxRollModal.youWonString";
      
      private const rewardsInVaultString:String = "MysteryBoxRollModal.rewardsInVaultString";
      
      private var minusNavSprite:Sprite;
      
      private var plusNavSprite:Sprite;
      
      private var boxButton:LegacyBuyButton = new LegacyBuyButton(this.playAgainString,16,0,Currency.INVALID);
      
      private var titleText:TextFieldDisplayConcrete;
      
      private var infoText:TextFieldDisplayConcrete;
      
      private var descTexts:Vector.<TextFieldDisplayConcrete> = new Vector.<TextFieldDisplayConcrete>();
      
      private var swapImageTimer:Timer = new Timer(50);
      
      private var totalRollTimer:Timer = new Timer(2000);
      
      private var nextRollTimer:Timer = new Timer(800);
      
      private var indexInRolls:Vector.<int> = new Vector.<int>();
      
      private var lastReward:String = "";
      
      private var requestComplete:Boolean = false;
      
      private var timerComplete:Boolean = false;
      
      private var goldBackground:DisplayObject = new EmbeddedAssets.EvolveBackground();
      
      private var goldBackgroundMask:DisplayObject = new EmbeddedAssets.EvolveBackground();
      
      public function MysteryBoxRollModal(param1:MysteryBoxInfo, param2:int)
      {
         super();
         this.mbi = param1;
         this.closeButton.disableLegacyCloseBehavior();
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseClick);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.infoText = this.getText(this.rewardsInVaultString,TEXT_MARGIN,220).setSize(20).setColor(0);
         this.infoText.y = 40;
         this.infoText.filters = [];
         this.addComponemts();
         open = true;
         this.boxButton.x += WIDTH / 2 - 100;
         this.boxButton.y += HEIGHT - 43;
         this.boxButton._width = 200;
         this.boxButton.addEventListener(MouseEvent.CLICK,this.onRollClick);
         this.minusNavSprite = UIAssetsHelper.createLeftNevigatorIcon(UIAssetsHelper.LEFT_NEVIGATOR,3);
         this.minusNavSprite.addEventListener(MouseEvent.CLICK,this.onNavClick);
         this.minusNavSprite.filters = [new GlowFilter(0,1,2,2,10,1)];
         this.minusNavSprite.x = WIDTH / 2 + 110;
         this.minusNavSprite.y = HEIGHT - 35;
         this.minusNavSprite.alpha = 0;
         addChild(this.minusNavSprite);
         this.plusNavSprite = UIAssetsHelper.createLeftNevigatorIcon(UIAssetsHelper.RIGHT_NEVIGATOR,3);
         this.plusNavSprite.addEventListener(MouseEvent.CLICK,this.onNavClick);
         this.plusNavSprite.filters = [new GlowFilter(0,1,2,2,10,1)];
         this.plusNavSprite.x = WIDTH / 2 + 110;
         this.plusNavSprite.y = HEIGHT - 50;
         this.plusNavSprite.alpha = 0;
         addChild(this.plusNavSprite);
         var _loc3_:Injector = StaticInjectorContext.getInjector();
         this.client = _loc3_.getInstance(AppEngineClient);
         this.account = _loc3_.getInstance(Account);
         var _loc4_:uint = 0;
         while(_loc4_ < this.mbi._rollsWithContents.length)
         {
            this.indexInRolls.push(0);
            _loc4_++;
         }
         this.centerModal();
         this.configureRollByQuantity(param2);
         this.sendRollRequest();
      }
      
      private static function makeModalBackground(param1:int, param2:int) : PopupWindowBackground
      {
         var _loc3_:PopupWindowBackground = new PopupWindowBackground();
         _loc3_.draw(param1,param2,PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
         return _loc3_;
      }
      
      private function configureRollByQuantity(param1:*) : *
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.quantity_ = param1;
         switch(param1)
         {
            case 1:
               this.rollCount = 1;
               this.rollTarget = 1;
               this.swapImageTimer.delay = 50;
               this.totalRollTimer.delay = 2000;
               break;
            case 5:
               this.rollCount = 0;
               this.rollTarget = 4;
               this.swapImageTimer.delay = 50;
               this.totalRollTimer.delay = 1000;
               break;
            case 10:
               this.rollCount = 0;
               this.rollTarget = 9;
               this.swapImageTimer.delay = 50;
               this.totalRollTimer.delay = 1000;
               break;
            default:
               this.rollCount = 1;
               this.rollTarget = 1;
               this.swapImageTimer.delay = 50;
               this.totalRollTimer.delay = 2000;
         }
         if(this.mbi.isOnSale())
         {
            _loc2_ = this.mbi.saleAmount * this.quantity_;
            _loc3_ = int(this.mbi.saleCurrency);
         }
         else
         {
            _loc2_ = this.mbi.priceAmount * this.quantity_;
            _loc3_ = int(this.mbi.priceCurrency);
         }
         if(this.quantity_ == 1)
         {
            this.boxButton.setPrice(_loc2_,this.mbi.priceCurrency);
         }
         else
         {
            this.boxButton.currency = _loc3_;
            this.boxButton.price = _loc2_;
            this.boxButton.setStringBuilder(new LineBuilder().setParams(this.playAgainXTimesString,{
               "cost":_loc2_.toString(),
               "repeat":this.quantity_.toString()
            }));
         }
      }
      
      public function getText(param1:String, param2:int, param3:int, param4:Boolean = false) : TextFieldDisplayConcrete
      {
         var _loc5_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(WIDTH - TEXT_MARGIN * 2);
         _loc5_.setBold(true);
         if(param4)
         {
            _loc5_.setStringBuilder(new StaticStringBuilder(param1));
         }
         else
         {
            _loc5_.setStringBuilder(new LineBuilder().setParams(param1));
         }
         _loc5_.setWordWrap(true);
         _loc5_.setMultiLine(true);
         _loc5_.setAutoSize(TextFieldAutoSize.CENTER);
         _loc5_.setHorizontalAlign(TextFormatAlign.CENTER);
         _loc5_.filters = [new DropShadowFilter(0,0,0)];
         _loc5_.x = param2;
         _loc5_.y = param3;
         return _loc5_;
      }
      
      private function addComponemts() : void
      {
         this.goldBackgroundMask.y = this.goldBackground.y = 27;
         this.goldBackgroundMask.x = this.goldBackground.x = 1;
         this.goldBackgroundMask.width = this.goldBackground.width = WIDTH - 1;
         this.goldBackgroundMask.height = this.goldBackground.height = HEIGHT - 28;
         addChild(this.goldBackground);
         addChild(this.goldBackgroundMask);
         var _loc3_:Spinner = new Spinner();
         var _loc4_:Spinner = new Spinner();
         _loc3_.degreesPerSecond = 50;
         _loc4_.degreesPerSecond = _loc3_.degreesPerSecond * 1.5;
         _loc4_.width = _loc3_.width * 0.7;
         _loc4_.height = _loc3_.height * 0.7;
         _loc4_.alpha = _loc3_.alpha = 0.7;
         this.spinners.addChild(_loc3_);
         this.spinners.addChild(_loc4_);
         this.spinners.mask = this.goldBackgroundMask;
         this.spinners.x = WIDTH / 2;
         this.spinners.y = (HEIGHT - 30) / 3 + 50;
         this.spinners.alpha = 0;
         addChild(this.spinners);
         addChild(makeModalBackground(WIDTH,HEIGHT));
         addChild(this.closeButton);
         this.particleModalMap = new ParticleModalMap(ParticleModalMap.MODE_AUTO_UPDATE);
         addChild(this.particleModalMap);
      }
      
      private function sendRollRequest() : void
      {
         if(!this.moneyCheckPass())
         {
            return;
         }
         this.state = this.ROLL_STATE;
         this.closeButton.visible = false;
         var _loc1_:Object = this.account.getCredentials();
         _loc1_.boxId = this.mbi.id;
         if(this.mbi.isOnSale())
         {
            _loc1_.quantity = this.mbi._quantity;
            _loc1_.price = this.mbi._saleAmount;
            _loc1_.currency = this.mbi._saleCurrency;
         }
         else
         {
            _loc1_.quantity = this.mbi._quantity;
            _loc1_.price = this.mbi._priceAmount;
            _loc1_.currency = this.mbi._priceCurrency;
         }
         this.client.sendRequest("/account/purchaseMysteryBox",_loc1_);
         this.titleText = this.getText(this.mbi._title,TEXT_MARGIN,6,true).setSize(18);
         this.titleText.setColor(16768512);
         addChild(this.titleText);
         addChild(this.infoText);
         this.playRollAnimation();
         this.lastReward = "";
         this.requestComplete = false;
         this.timerComplete = false;
         this.totalRollTimer.addEventListener(TimerEvent.TIMER,this.onTotalRollTimeComplete);
         this.totalRollTimer.start();
         this.client.complete.addOnce(this.onComplete);
      }
      
      private function playRollAnimation() : void
      {
         var _loc2_:Bitmap = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.mbi._rollsWithContents.length)
         {
            _loc2_ = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(this.mbi._rollsWithContentsUnique[this.indexInRolls[_loc1_]],this.iconSize,true));
            this.itemBitmaps.push(_loc2_);
            _loc1_++;
         }
         this.displayItems(this.itemBitmaps);
         this.swapImageTimer.addEventListener(TimerEvent.TIMER,this.swapItemImage);
         this.swapImageTimer.start();
      }
      
      private function onTotalRollTimeComplete(param1:TimerEvent) : void
      {
         this.totalRollTimer.stop();
         this.timerComplete = true;
         if(this.requestComplete)
         {
            this.showReward(this.lastReward);
         }
         this.totalRollTimer.removeEventListener(TimerEvent.TIMER,this.onTotalRollTimeComplete);
      }
      
      private function onNextRollTimerComplete(param1:TimerEvent) : void
      {
         this.nextRollTimer.stop();
         this.nextRollTimer.removeEventListener(TimerEvent.TIMER,this.onNextRollTimerComplete);
         this.shelveReward();
         this.clearReward();
         ++this.rollCount;
         this.sendRollRequest();
      }
      
      private function swapItemImage(param1:TimerEvent) : void
      {
         this.swapImageTimer.stop();
         var _loc2_:uint = 0;
         while(_loc2_ < this.indexInRolls.length)
         {
            if(this.indexInRolls[_loc2_] < this.mbi._rollsWithContentsUnique.length - 1)
            {
               ++this.indexInRolls[_loc2_];
            }
            else
            {
               this.indexInRolls[_loc2_] = 0;
            }
            this.itemBitmaps[_loc2_].bitmapData = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(this.mbi._rollsWithContentsUnique[this.indexInRolls[_loc2_]],this.iconSize,true)).bitmapData;
            _loc2_++;
         }
         this.swapImageTimer.start();
      }
      
      private function displayItems(param1:Vector.<Bitmap>) : void
      {
         var _loc2_:Bitmap = null;
         switch(param1.length)
         {
            case 1:
               param1[0].x += WIDTH / 2 - 40;
               param1[0].y += HEIGHT / 3;
               break;
            case 2:
               param1[0].x += WIDTH / 2 + 20;
               param1[0].y += HEIGHT / 3;
               param1[1].x += WIDTH / 2 - 100;
               param1[1].y += HEIGHT / 3;
               break;
            case 3:
               param1[0].x += WIDTH / 2 - 140;
               param1[0].y += HEIGHT / 3;
               param1[1].x += WIDTH / 2 - 40;
               param1[1].y += HEIGHT / 3;
               param1[2].x += WIDTH / 2 + 60;
               param1[2].y += HEIGHT / 3;
         }
         for each(_loc2_ in param1)
         {
            addChild(_loc2_);
         }
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Player = null;
         var _loc5_:PlayerModel = null;
         var _loc6_:OpenDialogSignal = null;
         var _loc7_:Dialog = null;
         var _loc8_:Injector = null;
         var _loc9_:GetMysteryBoxesTask = null;
         this.requestComplete = true;
         if(param1)
         {
            _loc3_ = new XML(param2);
            this.lastReward = _loc3_.Awards;
            if(this.timerComplete)
            {
               this.showReward(_loc3_.Awards);
            }
            _loc4_ = StaticInjectorContext.getInjector().getInstance(GameModel).player;
            if(_loc4_ != null)
            {
               if(_loc3_.hasOwnProperty("Gold"))
               {
                  _loc4_.setCredits(int(_loc3_.Gold));
               }
               else if(_loc3_.hasOwnProperty("Fame"))
               {
                  _loc4_.fame_ = _loc3_.Fame;
               }
            }
            else
            {
               _loc5_ = StaticInjectorContext.getInjector().getInstance(PlayerModel);
               if(_loc5_ != null)
               {
                  if(_loc3_.hasOwnProperty("Gold"))
                  {
                     _loc5_.setCredits(int(_loc3_.Gold));
                  }
                  else if(_loc3_.hasOwnProperty("Fame"))
                  {
                     _loc5_.setFame(int(_loc3_.Fame));
                  }
               }
            }
         }
         else
         {
            _loc6_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            _loc7_ = new Dialog("MysteryBoxRollModal.purchaseFailedString","MysteryBoxRollModal.pleaseTryAgainString","MysteryBoxRollModal.okString",null,null);
            _loc7_.addEventListener(Dialog.LEFT_BUTTON,this.onErrorOk);
            _loc6_.dispatch(_loc7_);
            _loc8_ = StaticInjectorContext.getInjector();
            _loc9_ = _loc8_.getInstance(GetMysteryBoxesTask);
            _loc9_.clearLastRanBlock();
            _loc9_.start();
            this.close(true);
         }
      }
      
      private function onErrorOk(param1:Event) : void
      {
         var _loc2_:OpenDialogSignal = null;
         _loc2_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
         _loc2_.dispatch(new MysteryBoxSelectModal());
      }
      
      public function moneyCheckPass() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc7_:OpenDialogSignal = null;
         var _loc8_:PlayerModel = null;
         if(this.mbi.isOnSale() && this.mbi.saleAmount != "")
         {
            _loc1_ = int(this.mbi.saleCurrency);
            _loc2_ = int(this.mbi.saleAmount) * this.quantity_;
         }
         else
         {
            _loc1_ = int(this.mbi.priceCurrency);
            _loc2_ = int(this.mbi.priceAmount) * this.quantity_;
         }
         var _loc3_:Boolean = true;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
         if(_loc6_ != null)
         {
            _loc5_ = _loc6_.credits_;
            _loc4_ = _loc6_.fame_;
         }
         else
         {
            _loc8_ = StaticInjectorContext.getInjector().getInstance(PlayerModel);
            if(_loc8_ != null)
            {
               _loc5_ = _loc8_.getCredits();
               _loc4_ = _loc8_.getFame();
            }
         }
         if(_loc1_ == Currency.GOLD && _loc5_ < _loc2_)
         {
            _loc7_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            _loc7_.dispatch(new NotEnoughGoldDialog());
            _loc3_ = false;
         }
         else if(_loc1_ == Currency.FAME && _loc4_ < _loc2_)
         {
            _loc7_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            _loc7_.dispatch(new NotEnoughFameDialog());
            _loc3_ = false;
         }
         return _loc3_;
      }
      
      public function onCloseClick(param1:MouseEvent) : void
      {
         this.close();
      }
      
      private function close(param1:Boolean = false) : void
      {
         var _loc2_:OpenDialogSignal = null;
         if(this.state == this.ROLL_STATE)
         {
            return;
         }
         if(!param1)
         {
            _loc2_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            if(this.parentSelectModal != null)
            {
               _loc2_.dispatch(this.parentSelectModal);
            }
            else
            {
               _loc2_.dispatch(new MysteryBoxSelectModal());
            }
         }
         open = false;
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         open = false;
      }
      
      private function showReward(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:TextFieldDisplayConcrete = null;
         this.swapImageTimer.removeEventListener(TimerEvent.TIMER,this.swapItemImage);
         this.swapImageTimer.stop();
         this.state = this.IDLE_STATE;
         if(this.rollCount < this.rollTarget)
         {
            this.nextRollTimer.addEventListener(TimerEvent.TIMER,this.onNextRollTimerComplete);
            this.nextRollTimer.start();
         }
         this.closeButton.visible = true;
         var _loc2_:Array = param1.split(",");
         removeChild(this.infoText);
         this.titleText.setStringBuilder(new LineBuilder().setParams(this.youWonString));
         this.titleText.setColor(16768512);
         var _loc3_:int = 40;
         for each(_loc4_ in _loc2_)
         {
            _loc6_ = this.getText(ObjectLibrary.typeToDisplayId_[_loc4_],TEXT_MARGIN,_loc3_).setSize(16).setColor(0);
            _loc6_.filters = [];
            _loc6_.setSize(18);
            _loc6_.x = 20;
            addChild(_loc6_);
            this.descTexts.push(_loc6_);
            _loc3_ += 25;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(_loc5_ < this.itemBitmaps.length)
            {
               this.itemBitmaps[_loc5_].bitmapData = new Bitmap(ObjectLibrary.getRedrawnTextureFromType(int(_loc2_[_loc5_]),this.iconSize,true)).bitmapData;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.itemBitmaps.length)
         {
            this.doEaseInAnimation(this.itemBitmaps[_loc5_],{
               "scaleX":1.25,
               "scaleY":1.25
            },{
               "scaleX":1,
               "scaleY":1
            });
            _loc5_++;
         }
         this.boxButton.alpha = 0;
         addChild(this.boxButton);
         if(this.rollCount == this.rollTarget)
         {
            this.doEaseInAnimation(this.boxButton,{"alpha":0},{"alpha":1});
            this.doEaseInAnimation(this.minusNavSprite,{"alpha":0},{"alpha":1});
            this.doEaseInAnimation(this.plusNavSprite,{"alpha":0},{"alpha":1});
         }
         this.doEaseInAnimation(this.spinners,{"alpha":0},{"alpha":1});
         this.isShowReward = true;
      }
      
      private function doEaseInAnimation(param1:DisplayObject, param2:Object = null, param3:Object = null) : void
      {
         var _loc4_:GTween = new GTween(param1,0.5 * 1,param2,{"ease":Sine.easeOut});
         _loc4_.nextTween = new GTween(param1,0.5 * 1,param3,{"ease":Sine.easeIn});
         _loc4_.nextTween.paused = true;
      }
      
      private function shelveReward() : void
      {
         var _loc2_:ItemWithTooltip = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:Array = this.lastReward.split(",");
         if(_loc1_.length > 0)
         {
            _loc2_ = new ItemWithTooltip(int(_loc1_[0]),64);
            _loc3_ = HEIGHT / 6 - 10;
            _loc4_ = WIDTH - 65;
            _loc2_.x = 5 + _loc4_ * int(this.rollCount / 5);
            _loc2_.y = 80 + _loc3_ * (this.rollCount % 5);
            _loc5_ = WIDTH / 2 - 40 + this.itemBitmaps[0].width * 0.5;
            _loc6_ = HEIGHT / 3 + this.itemBitmaps[0].height * 0.5;
            _loc7_ = _loc2_.x + _loc2_.height * 0.5;
            _loc8_ = 100 + _loc3_ * (this.rollCount % 5) + 0.5 * (HEIGHT / 6 - 20);
            this.particleModalMap.doLightning(_loc5_,_loc6_,_loc7_,_loc8_,115,15787660,0.2);
            addChild(_loc2_);
            this.rewardsArray.push(_loc2_);
         }
      }
      
      private function clearReward() : void
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         var _loc2_:Bitmap = null;
         this.spinners.alpha = 0;
         this.minusNavSprite.alpha = 0;
         this.plusNavSprite.alpha = 0;
         removeChild(this.titleText);
         for each(_loc1_ in this.descTexts)
         {
            removeChild(_loc1_);
         }
         while(this.descTexts.length > 0)
         {
            this.descTexts.pop();
         }
         removeChild(this.boxButton);
         for each(_loc2_ in this.itemBitmaps)
         {
            removeChild(_loc2_);
         }
         while(this.itemBitmaps.length > 0)
         {
            this.itemBitmaps.pop();
         }
      }
      
      private function clearShelveReward() : void
      {
         var _loc1_:ItemWithTooltip = null;
         for each(_loc1_ in this.rewardsArray)
         {
            removeChild(_loc1_);
         }
         while(this.rewardsArray.length > 0)
         {
            this.rewardsArray.pop();
         }
      }
      
      private function centerModal() : void
      {
         x = WebMain.STAGE.stageWidth / 2 - WIDTH / 2;
         y = WebMain.STAGE.stageHeight / 2 - HEIGHT / 2;
      }
      
      private function onNavClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget == this.minusNavSprite)
         {
            switch(this.quantity_)
            {
               case 5:
                  this.configureRollByQuantity(1);
                  break;
               case 10:
                  this.configureRollByQuantity(5);
            }
         }
         else if(param1.currentTarget == this.plusNavSprite)
         {
            switch(this.quantity_)
            {
               case 1:
                  this.configureRollByQuantity(5);
                  break;
               case 5:
                  this.configureRollByQuantity(10);
            }
         }
      }
      
      private function onRollClick(param1:MouseEvent) : void
      {
         this.configureRollByQuantity(this.quantity_);
         this.clearReward();
         this.clearShelveReward();
         this.sendRollRequest();
      }
   }
}

