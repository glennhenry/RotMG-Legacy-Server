package kabam.rotmg.fortune.components
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.map.ParticleModalMap;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.objects.particles.LightningEffect;
   import com.company.assembleegameclient.objects.particles.NovaEffect;
   import com.company.assembleegameclient.ui.dialogs.DebugDialog;
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import com.company.assembleegameclient.util.Currency;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Sine;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.EmptyFrame;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.fortune.model.FortuneInfo;
   import kabam.rotmg.fortune.services.FortuneModel;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.game.view.CreditDisplay;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.ui.view.NotEnoughGoldDialog;
   import kabam.rotmg.ui.view.components.MapBackground;
   import kabam.rotmg.util.components.CountdownTimer;
   import kabam.rotmg.util.components.InfoHoverPaneFactory;
   import kabam.rotmg.util.components.SimpleButton;
   import org.osflash.signals.Signal;
   import org.swiftsuspenders.Injector;
   
   public class FortuneModal extends EmptyFrame
   {
      
      private static var texts_:Vector.<TextField>;
      
      public static var fMouseX:int;
      
      public static var fMouseY:int;
      
      public static var backgroundImageEmbed:Class = FortuneModal_backgroundImageEmbed;
      
      public static var fortunePlatformEmbed:Class = FortuneModal_fortunePlatformEmbed;
      
      public static var fortunePlatformEmbed2:Class = FortuneModal_fortunePlatformEmbed2;
      
      public static const MODAL_WIDTH:int = 800;
      
      public static const MODAL_HEIGHT:int = 600;
      
      public static var modalWidth:int = MODAL_WIDTH;
      
      public static var modalHeight:int = MODAL_HEIGHT;
      
      public static const STATE_ROUND_1:int = 1;
      
      public static const STATE_ROUND_2:int = 2;
      
      public static const INIT_RADIUS_FROM_MAINCRYTAL:Number = 200;
      
      public static var crystalMainY:int = MODAL_HEIGHT / 2 - 20;
      
      private static const ITEM_SIZE_IN_MC:int = 120;
      
      public static var modalIsOpen:Boolean = false;
      
      public static const closed:Signal = new Signal();
      
      public var crystalMain:CrystalMain = new CrystalMain();
      
      public var crystals:Vector.<CrystalSmall> = Vector.<CrystalSmall>([new CrystalSmall(),new CrystalSmall(),new CrystalSmall()]);
      
      public var crystalClicked:CrystalSmall = null;
      
      private var buyButtonGold:SimpleButton = new SimpleButton("Play for ",0,Currency.INVALID);
      
      private var buyButtonFortune:SimpleButton = new SimpleButton("Play for ",0,Currency.INVALID);
      
      private var resetButton:SimpleButton = new SimpleButton("Return",0,Currency.INVALID);
      
      private var largeCloseButton:DialogCloseButton;
      
      private var currentString:int = -1;
      
      private var countdownTimer:CountdownTimer;
      
      public var client:AppEngineClient;
      
      public var account:Account;
      
      public var model:FortuneModel;
      
      public var fortuneInfo:FortuneInfo;
      
      public var state:int = 1;
      
      private var particleMap:ParticleModalMap;
      
      private const SWITCH_DELAY_NORMAL:Number = 1200;
      
      private const SWITCH_DELAY_FAST:Number = 100;
      
      private var itemSwitchTimer:Timer = new Timer(this.SWITCH_DELAY_NORMAL);
      
      private var tooltipItemIDIndex:int = -1;
      
      private var currenttooltipItem:int = 0;
      
      public var tooltipItems:Vector.<ItemWithTooltip>;
      
      private var lastUpdate_:int;
      
      public var mapBackground:MapBackground;
      
      private var pscale:Number;
      
      private var gameStage_:int = 0;
      
      private var boughtWithGold:Boolean = false;
      
      private const GAME_STAGE_IDLE:int = 0;
      
      private const GAME_STAGE_SPIN:int = 1;
      
      private var radius:int = 200;
      
      private var dtBuildup:Number = 0;
      
      private var direction:int = 4;
      
      private var spinSpeed:int = 0;
      
      private const MAX_SPIN_SPEED:int = 120;
      
      private var platformMain:Sprite;
      
      private var platformMainSub:Sprite;
      
      private const MASTERS_LORE_STRING_TIME:Number = 1.3;
      
      private const SHOW_PRIZES_TIME:Number = 6;
      
      private const SPIN_TIME:Number = 2.75;
      
      private const DISPLAY_PRIZE_TIME_1:Number = 3.75;
      
      private const DISPLAY_PRIZE_TIME_2:Number = 5;
      
      private const NOVA_DELAY_TIME:Number = 0.12;
      
      private const COUNTDOWN_AMOUNT:Number = 10;
      
      public var creditDisplay_:CreditDisplay;
      
      private var onHoverPanel:Sprite;
      
      private var goldPrice_:int = -1;
      
      private var goldPriceSecond_:int = -1;
      
      private var tokenPrice_:int = -1;
      
      private var gs_:GameSprite = null;
      
      private var chooseingState:Boolean = false;
      
      private var items:Array;
      
      public function FortuneModal(param1:GameSprite = null)
      {
         modalWidth = MODAL_WIDTH;
         modalHeight = MODAL_HEIGHT;
         super(modalWidth,modalHeight);
         modalIsOpen = true;
         this.makePlatforms();
         this.pscale = ParticleModalMap.PSCALE;
         this.particleMap = new ParticleModalMap();
         addChild(this.particleMap);
         this.largeCloseButton = new DialogCloseButton(1);
         addChild(this.largeCloseButton);
         this.largeCloseButton.y = 4;
         this.largeCloseButton.x = modalWidth - this.largeCloseButton.width - 5;
         var _loc2_:Injector = StaticInjectorContext.getInjector();
         this.client = _loc2_.getInstance(AppEngineClient);
         this.account = _loc2_.getInstance(Account);
         this.model = _loc2_.getInstance(FortuneModel);
         this.fortuneInfo = this.model.getFortune();
         if(this.fortuneInfo == null)
         {
            return;
         }
         this.crystalMain.setXPos(modalWidth / 2);
         this.crystalMain.setYPos(crystalMainY);
         this.resetBalls();
         addChild(this.crystalMain);
         this.lastUpdate_ = getTimer();
         this.countdownTimer = new CountdownTimer();
         this.countdownTimer.timerComplete.add(this.onCountdownComplete);
         addChild(this.countdownTimer);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         addEventListener(Event.REMOVED_FROM_STAGE,this.destruct);
         this.creditDisplay_ = new CreditDisplay(null,false,true);
         this.creditDisplay_.x = 734;
         this.creditDisplay_.y = 0;
         addChild(this.creditDisplay_);
         var _loc3_:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
         if(_loc3_ != null)
         {
            this.creditDisplay_.draw(_loc3_.credits_,0,_loc3_.tokens_);
         }
         if(param1 != null)
         {
            this.gs_ = param1;
            this.gs_.creditDisplay_.visible = false;
         }
         var _loc4_:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",1172);
         _loc4_ = TextureRedrawer.redraw(_loc4_,75,true,0);
         this.crystalMain.addEventListener(MouseEvent.ROLL_OVER,this.displayInfoHover);
         this.crystalMain.addEventListener(MouseEvent.ROLL_OUT,this.removeInfoHover);
         this.onHoverPanel = InfoHoverPaneFactory.make(this.fortuneInfo.infoImage);
         this.onHoverPanel.x = modalWidth - (this.onHoverPanel.width + 10);
         this.onHoverPanel.y = 10;
         this.addItemSwitch();
         this.InitTexts();
         this.setString(0);
         this.InitButtons();
         addChild(this.onHoverPanel);
         this.onHoverPanel.addEventListener(MouseEvent.ROLL_OVER,this.removeInfoHover);
         this.onHoverPanel.visible = false;
      }
      
      public static function doEaseOutInAnimation(param1:DisplayObject, param2:Object = null, param3:Object = null, param4:Function = null) : void
      {
         var _loc5_:GTween = new GTween(param1,0.5 * 1,param2,{"ease":Sine.easeOut});
         _loc5_.nextTween = new GTween(param1,0.5 * 1,param3,{"ease":Sine.easeIn});
         _loc5_.nextTween.paused = true;
         _loc5_.nextTween.end();
         _loc5_.nextTween.onComplete = param4;
      }
      
      private function displayInfoHover(param1:MouseEvent) : void
      {
         this.onHoverPanel.visible = true;
      }
      
      private function removeInfoHover(param1:MouseEvent) : void
      {
         if(!(param1.relatedObject is ItemWithTooltip))
         {
            this.onHoverPanel.visible = false;
         }
      }
      
      private function InitButtons() : void
      {
         this.goldPrice_ = int(this.fortuneInfo.priceFirstInGold);
         this.tokenPrice_ = int(this.fortuneInfo.priceFirstInToken);
         this.goldPriceSecond_ = int(this.fortuneInfo.priceSecondInGold);
         this.buyButtonGold.setPrice(this.goldPrice_,Currency.GOLD);
         this.buyButtonGold.setEnabled(true);
         this.buyButtonGold.x = modalWidth / 2 - 100 - this.buyButtonGold.width;
         this.buyButtonGold.y = modalHeight * 70 / 75 - this.buyButtonGold.height / 2;
         addChild(this.buyButtonGold);
         this.buyButtonGold.addEventListener(MouseEvent.CLICK,this.onBuyWithGoldClick);
         this.buyButtonFortune.setPrice(this.tokenPrice_,Currency.FORTUNE);
         this.buyButtonFortune.setEnabled(true);
         this.resetButton.visible = false;
         addChild(this.resetButton);
         this.resetButton.setText("Return");
         addChild(this.buyButtonFortune);
         this.buyButtonFortune.x = modalWidth / 2 + 100;
         this.buyButtonFortune.y = modalHeight * 70 / 75 - this.buyButtonFortune.height / 2;
         this.resetButton.x = modalWidth / 2 + 100;
         this.resetButton.y = modalHeight * 70 / 75 - this.buyButtonFortune.height / 2;
         this.buyButtonFortune.addEventListener(MouseEvent.CLICK,this.onBuyWithFortuneClick);
      }
      
      private function InitTexts() : void
      {
         var _loc4_:TextField = null;
         texts_ = new Vector.<TextField>();
         var _loc1_:Vector.<String> = Vector.<String>(["HOW WILL YOU PLAY?","THE FIVE MASTERS OF GOZOR WILL DETERMINE YOUR PRIZE!","HERE\'S WHAT YOU CAN WIN!","Shuffling!","PICK ONE TO WIN A PRIZE!","YOU WON! ITEMS WILL BE PLACED IN YOUR GIFT CHEST","TWO ITEMS LEFT! TAKE ANOTHER SHOT!","PICK A SECOND PRIZE!","PLAY AGAIN?","Choose now or I will choose for you!","Determining Prizes!","Sorting Loot!","What can you win?","Big Prizes! Big Orbs! I love it!","Wooah! Awesome lewt!","Processing hadoop data..."]);
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.size = 24;
         _loc2_.font = "Myriad Pro";
         _loc2_.bold = false;
         _loc2_.align = TextFormatAlign.LEFT;
         _loc2_.leftMargin = 0;
         _loc2_.indent = 0;
         _loc2_.leading = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = new TextField();
            _loc4_.text = _loc1_[_loc3_];
            _loc4_.textColor = 16776960;
            _loc4_.autoSize = TextFieldAutoSize.CENTER;
            _loc4_.selectable = false;
            _loc4_.defaultTextFormat = _loc2_;
            _loc4_.setTextFormat(_loc2_);
            _loc4_.filters = [new GlowFilter(16777215,1,2,2,1.5,1)];
            texts_.push(_loc4_);
            _loc3_++;
         }
      }
      
      private function setString(param1:int) : void
      {
         if(this.parent == null)
         {
            return;
         }
         if(this.currentString >= 0 && texts_[this.currentString].parent != null)
         {
            removeChild(texts_[this.currentString]);
         }
         if(param1 < 0)
         {
            return;
         }
         this.currentString = param1;
         var _loc2_:TextField = texts_[this.currentString];
         _loc2_.x = modalWidth / 2 - _loc2_.width / 2;
         _loc2_.y = modalHeight * 66 / 75 - _loc2_.height / 2;
         addChild(texts_[this.currentString]);
      }
      
      private function destruct(param1:Event) : void
      {
         this.largeCloseButton.clicked.removeAll();
         modalIsOpen = false;
         closed.dispatch();
         closed.removeAll();
         this.itemSwitchTimer.removeEventListener(TimerEvent.TIMER,this.onItemSwitch);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.destruct);
         this.countdownTimer.timerComplete.removeAll();
         this.countdownTimer.end();
         this.countdownTimer = null;
         this.buyButtonsDisable();
         this.ballClickDisable();
         this.crystalMain.removeEventListener(MouseEvent.ROLL_OVER,this.displayInfoHover);
         this.crystalMain.removeEventListener(MouseEvent.ROLL_OUT,this.removeInfoHover);
         this.onHoverPanel.removeEventListener(MouseEvent.ROLL_OVER,this.removeInfoHover);
         this.resetButton.removeEventListener(MouseEvent.CLICK,this.onResetClick);
         if(this.gs_ != null)
         {
            this.gs_.creditDisplay_.visible = false;
         }
      }
      
      private function onItemSwitch(param1:TimerEvent = null) : void
      {
         var _loc5_:ItemWithTooltip = null;
         ++this.tooltipItemIDIndex;
         if(this.tooltipItems == null)
         {
            this.tooltipItems = Vector.<ItemWithTooltip>([new ItemWithTooltip(this.fortuneInfo._rollsWithContentsUnique[this.tooltipItemIDIndex],ITEM_SIZE_IN_MC),new ItemWithTooltip(this.fortuneInfo._rollsWithContentsUnique[this.tooltipItemIDIndex + 1],ITEM_SIZE_IN_MC)]);
         }
         if(this.tooltipItemIDIndex >= this.fortuneInfo._rollsWithContentsUnique.length)
         {
            this.tooltipItemIDIndex = 0;
         }
         var _loc2_:int = this.tooltipItemIDIndex % 2;
         if(this.tooltipItems[this.currenttooltipItem] != null && this.tooltipItems[this.currenttooltipItem].parent != null)
         {
            _loc5_ = this.tooltipItems[this.currenttooltipItem];
            this.doEaseInAnimation(_loc5_,{"alpha":0},this.removeChildAfterTween);
         }
         var _loc3_:ItemWithTooltip = new ItemWithTooltip(this.fortuneInfo._rollsWithContentsUnique[this.tooltipItemIDIndex],ITEM_SIZE_IN_MC,true);
         _loc3_.onMouseOver.add(this.onItemSwitchPause);
         _loc3_.onMouseOut.add(this.onItemSwitchContinue);
         _loc3_.setXPos(this.crystalMain.getCenterX());
         _loc3_.setYPos(this.crystalMain.getCenterY());
         this.tooltipItems[_loc2_] = _loc3_;
         _loc3_.alpha = 0;
         addChild(_loc3_);
         this.doEaseInAnimation(_loc3_,{"alpha":1});
         this.currenttooltipItem = _loc2_;
         var _loc4_:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
         if(this.creditDisplay_ != null && _loc4_ != null)
         {
            this.creditDisplay_.draw(_loc4_.credits_,0,_loc4_.tokens_);
         }
      }
      
      private function removeChildAfterTween(param1:GTween) : void
      {
         if(param1.target.parent != null)
         {
            param1.target.parent.removeChild(param1.target);
         }
      }
      
      public function onItemSwitchPause() : void
      {
         this.itemSwitchTimer.stop();
      }
      
      public function onItemSwitchContinue() : void
      {
         this.itemSwitchTimer.start();
         this.onItemSwitch();
      }
      
      public function addItemSwitch() : void
      {
         this.itemSwitchTimer.delay = this.SWITCH_DELAY_NORMAL;
         this.itemSwitchTimer.addEventListener(TimerEvent.TIMER,this.onItemSwitch);
         this.onItemSwitchContinue();
      }
      
      private function removeItemSwitch() : void
      {
         this.itemSwitchTimer.removeEventListener(TimerEvent.TIMER,this.onItemSwitch);
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            if(this.tooltipItems[_loc1_] != null && this.tooltipItems[_loc1_].parent != null)
            {
               this.tooltipItems[_loc1_].alpha = 0;
               this.tooltipItems[_loc1_].onMouseOut.removeAll();
               this.tooltipItems[_loc1_].onMouseOver.removeAll();
               this.tooltipItems[_loc1_].parent.removeChild(this.tooltipItems[_loc1_]);
            }
            _loc1_++;
         }
         this.onItemSwitchPause();
      }
      
      private function canUseFortuneModal() : Boolean
      {
         return FortuneModel.HAS_FORTUNES;
      }
      
      private function doEaseInAnimation(param1:DisplayObject, param2:Object = null, param3:Function = null) : void
      {
         var _loc4_:GTween = new GTween(param1,0.5,param2,{
            "ease":Sine.easeOut,
            "onComplete":param3
         });
      }
      
      private function onCountdownComplete() : void
      {
         var _loc2_:int = 0;
         var _loc1_:CrystalSmall = null;
         do
         {
            _loc2_ = int(Math.random() * 3);
            if(this.state == STATE_ROUND_1 || this.crystals[_loc2_] != this.crystalClicked)
            {
               _loc1_ = this.crystals[_loc2_];
            }
         }
         while(_loc1_ == null);
         this.smallBallClick(_loc1_);
      }
      
      protected function makePlatforms() : void
      {
         var _loc1_:ImageSprite = null;
         this.platformMain = new Sprite();
         _loc1_ = new ImageSprite(new fortunePlatformEmbed2(),500,500);
         _loc1_.x = -_loc1_.width / 2;
         _loc1_.y = -_loc1_.height / 2;
         this.platformMain.addChild(_loc1_);
         this.platformMain.x = modalWidth / 2;
         this.platformMain.y = crystalMainY;
         this.platformMain.alpha = 0.25;
         addChild(this.platformMain);
         this.platformMainSub = new Sprite();
         _loc1_ = new ImageSprite(new fortunePlatformEmbed(),700,700);
         _loc1_.x = -_loc1_.width / 2;
         _loc1_.y = -_loc1_.height / 2;
         this.platformMainSub.addChild(_loc1_);
         this.platformMainSub.x = modalWidth / 2;
         this.platformMainSub.y = crystalMainY;
         this.platformMainSub.alpha = 0.15;
         addChild(this.platformMainSub);
      }
      
      override protected function makeModalBackground() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:DisplayObject = new backgroundImageEmbed();
         _loc2_.width = modalWidth;
         _loc2_.height = modalHeight;
         _loc2_.alpha = 0.7;
         _loc1_.addChild(_loc2_);
         return _loc1_;
      }
      
      private function onResetClick(param1:MouseEvent) : void
      {
         this.resetButton.removeEventListener(MouseEvent.CLICK,this.onResetClick);
         this.resetGame();
      }
      
      private function onBuyWithGoldClick(param1:MouseEvent) : void
      {
         this.onFirstBuySub(Currency.GOLD);
      }
      
      private function onBuyWithFortuneClick(param1:MouseEvent) : void
      {
         this.onFirstBuySub(Currency.FORTUNE);
      }
      
      private function onFirstBuySub(param1:int) : void
      {
         var _loc4_:OpenDialogSignal = null;
         if(!this.canUseFortuneModal())
         {
            this.fortuneEventOver();
         }
         var _loc2_:Player = StaticInjectorContext.getInjector().getInstance(GameModel).player;
         if(_loc2_ != null)
         {
            if(param1 == Currency.GOLD && this.state == STATE_ROUND_2 && _loc2_.credits_ - this.goldPriceSecond_ < 0)
            {
               _loc4_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
               _loc4_.dispatch(new NotEnoughGoldDialog());
               return;
            }
            if(param1 == Currency.GOLD && _loc2_.credits_ - this.goldPrice_ < 0)
            {
               _loc4_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
               _loc4_.dispatch(new NotEnoughGoldDialog());
               return;
            }
            if(param1 == Currency.FORTUNE && _loc2_.tokens_ - this.tokenPrice_ < 0)
            {
               return;
            }
         }
         this.itemSwitchTimer.delay = this.SWITCH_DELAY_FAST;
         this.crystalMain.setAnimationStage(CrystalMain.ANIMATION_STAGE_WAITING);
         var _loc3_:Object = this.makeBasicParams();
         if(param1 == Currency.FORTUNE)
         {
            _loc3_.currency = 2;
         }
         else
         {
            if(param1 != Currency.GOLD)
            {
               return;
            }
            _loc3_.currency = 0;
         }
         if(this.state == STATE_ROUND_1)
         {
            _loc3_.status = 0;
            this.crystalMain.removeEventListener(MouseEvent.ROLL_OVER,this.displayInfoHover);
         }
         if(this.state == STATE_ROUND_1 && !this.client.requestInProgress())
         {
            this.buyButtonsDisable();
            this.boughtWithGold = param1 == Currency.GOLD;
            if(_loc2_ != null)
            {
               if(this.boughtWithGold)
               {
                  _loc2_.credits_ -= this.goldPrice_;
                  this.creditDisplay_.draw(_loc2_.credits_,0,_loc2_.tokens_);
               }
               else
               {
                  if(_loc2_.tokens_ - this.tokenPrice_ < 0)
                  {
                     return;
                  }
                  _loc2_.tokens_ -= this.tokenPrice_;
                  this.creditDisplay_.draw(_loc2_.credits_,0,_loc2_.tokens_);
               }
            }
            this.client.sendRequest("/account/playFortuneGame",_loc3_);
            this.setString(10 + int(Math.random() * 6));
            this.client.complete.addOnce(this.onFirstBuyComplete);
            this.buyButtonGold.visible = false;
            this.buyButtonFortune.visible = false;
         }
         else if(this.state == STATE_ROUND_2)
         {
            this.buyButtonsDisable();
            this.onFirstBuyAnimateSub();
            _loc2_ = StaticInjectorContext.getInjector().getInstance(GameModel).player;
            if(_loc2_ != null)
            {
               _loc2_.credits_ -= this.goldPriceSecond_;
               this.creditDisplay_.draw(_loc2_.credits_,0,_loc2_.tokens_);
            }
            this.buyButtonGold.visible = false;
            this.resetButton.visible = false;
         }
      }
      
      private function onFirstBuyComplete(param1:Boolean, param2:*) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Player = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:String = null;
         if(param1)
         {
            _loc3_ = new XML(param2);
            this.items = _loc3_.Candidates.split(",");
            _loc4_ = StaticInjectorContext.getInjector().getInstance(GameModel).player;
            if(_loc4_ != null)
            {
               if(_loc3_.hasOwnProperty("Gold"))
               {
                  _loc4_.credits_ = int(_loc3_.Gold);
                  this.creditDisplay_.draw(_loc4_.credits_,0,_loc4_.tokens_);
               }
               else if(_loc3_.hasOwnProperty("FortuneToken"))
               {
                  _loc4_.tokens_ = int(_loc3_.FortuneToken);
                  this.creditDisplay_.draw(_loc4_.credits_,0,_loc4_.tokens_);
               }
            }
            _loc5_ = Vector.<int>([0,2,1]);
            _loc6_ = Math.floor(Math.random() * 3);
            _loc7_ = Math.random() > 0.5;
            _loc8_ = this.crystalMain.getCenterX();
            _loc9_ = this.crystalMain.getCenterY();
            _loc10_ = this.crystals[_loc5_[_loc6_]].getCenterX();
            _loc11_ = this.crystals[_loc5_[_loc6_]].getCenterY();
            _loc12_ = 0;
            _loc13_ = _loc8_;
            _loc14_ = _loc9_;
            _loc15_ = 0.25;
            _loc16_ = 1.2;
            this.removeItemSwitch();
            for each(_loc17_ in this.items)
            {
               if(_loc12_ == 0)
               {
                  new TimerCallback(_loc15_,this.doLightning,_loc8_,_loc9_,_loc10_,_loc11_);
                  new TimerCallback(_loc15_ + 0.1,this.crystals[_loc5_[_loc6_]].doItemShow,int(_loc17_));
               }
               else
               {
                  _loc10_ = this.crystals[_loc5_[_loc6_]].getCenterX();
                  _loc11_ = this.crystals[_loc5_[_loc6_]].getCenterY();
                  new TimerCallback(_loc15_,this.doLightning,_loc13_,_loc14_,_loc10_,_loc11_);
                  new TimerCallback(_loc15_ + 0.1,this.crystals[_loc5_[_loc6_]].doItemShow,int(_loc17_));
               }
               _loc13_ = _loc10_;
               _loc14_ = _loc11_;
               _loc15_ += _loc16_;
               _loc12_++;
               if(_loc7_)
               {
                  _loc6_ = (_loc6_ + 1) % 3;
               }
               else
               {
                  _loc6_ = --_loc6_ < 0 ? 2 : _loc6_;
               }
            }
            new TimerCallback(this.SHOW_PRIZES_TIME,this.onFirstBuyAnimateSub);
         }
         else
         {
            this.handleError();
         }
      }
      
      private function onFirstBuyAnimateSub() : void
      {
         if(this.state == STATE_ROUND_2 && this.crystalClicked != null)
         {
            this.resetBallsRound2();
         }
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.crystals[_loc1_].removeItemReveal();
            this.crystals[_loc1_].saveReturnPotion();
            this.crystals[_loc1_].setAnimation(6,7);
            this.crystals[_loc1_].setAnimationDuration(50);
            _loc1_++;
         }
         this.setGameStage(this.GAME_STAGE_SPIN);
         this.crystalMain.setAnimationStage(CrystalMain.ANIMATION_STAGE_INNERROTATION);
         new TimerCallback(this.SPIN_TIME,this.onFirstBuyAnimateComplete);
         this.setString(3);
      }
      
      private function onFirstBuyAnimateComplete() : void
      {
         this.setGameStage(this.GAME_STAGE_IDLE);
         if(this.state == STATE_ROUND_2)
         {
            this.setString(7);
         }
         else
         {
            this.setString(4);
         }
         this.ballClickEnable(this.crystalClicked);
         this.crystalMain.setAnimationStage(CrystalMain.ANIMATION_STAGE_BUZZING);
         this.doNova(this.crystalMain.getCenterX(),this.crystalMain.getCenterY(),10,65535);
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            if(!(this.state == STATE_ROUND_2 && this.crystals[_loc1_] == this.crystalClicked))
            {
               this.crystals[_loc1_].setActive2();
               this.crystals[_loc1_].doItemReturn();
               new TimerCallback(this.NOVA_DELAY_TIME,this.doNova,int(this.crystals[_loc1_].returnCenterX()),int(this.crystals[_loc1_].returnCenterY()),5,65535);
               new TimerCallback(this.NOVA_DELAY_TIME,this.crystals[_loc1_].setAnimationPulse);
            }
            _loc1_++;
         }
         if(this.countdownTimer == null)
         {
            return;
         }
         new TimerCallback(this.NOVA_DELAY_TIME,this.crystalMain.setAnimationStage,CrystalMain.ANIMATION_STAGE_PULSE);
         this.countdownTimer.start(this.COUNTDOWN_AMOUNT);
         this.countdownTimer.setXPos(this.crystalMain.getCenterX());
         this.countdownTimer.setYPos(this.crystalMain.getCenterY());
         new TimerCallback(7,this.setCountdownWarningString);
         this.chooseingState = true;
      }
      
      private function setCountdownWarningString() : void
      {
         if(this.countdownTimer != null && this.countdownTimer.isRunning())
         {
            this.setString(9);
         }
      }
      
      private function handleError() : void
      {
         var _loc1_:OpenDialogSignal = null;
         _loc1_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
         var _loc2_:Dialog = new Dialog("MysteryBoxRollModal.purchaseFailedString","MysteryBoxRollModal.pleaseTryAgainString","MysteryBoxRollModal.okString",null,null);
         _loc2_.addEventListener(Dialog.LEFT_BUTTON,this.onErrorOk,false,0,true);
         _loc1_.dispatch(_loc2_);
      }
      
      private function onErrorOk(param1:Event) : void
      {
         var _loc2_:CloseDialogsSignal = null;
         _loc2_ = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
         _loc2_.dispatch();
      }
      
      private function fortuneEventOver() : void
      {
         var _loc1_:OpenDialogSignal = null;
         _loc1_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
         _loc1_.dispatch(new DebugDialog("The Alchemist has left the Nexus.Please check back later.","Oh no!"));
      }
      
      private function makeBasicParams() : Object
      {
         var _loc1_:Object = this.account.getCredentials();
         _loc1_.gameId = this.fortuneInfo.id;
         return _loc1_;
      }
      
      private function onSmallBallClick(param1:MouseEvent) : void
      {
         this.smallBallClick(param1.currentTarget);
      }
      
      private function smallBallClick(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            if(this.crystals[_loc3_] == param1)
            {
               this.smallBallClickSub(_loc3_,_loc2_);
               this.crystals[_loc3_].setAnimationClicked();
            }
            if(this.crystals[_loc3_] != this.crystalClicked)
            {
               _loc2_++;
            }
            this.crystals[_loc3_].setGlowState(CrystalSmall.GLOW_STATE_FADE);
            _loc3_++;
         }
         this.chooseingState = false;
      }
      
      private function smallBallClickSub(param1:int, param2:int) : void
      {
         var _loc3_:Object = this.makeBasicParams();
         _loc3_.choice = param2;
         _loc3_.status = this.state;
         _loc3_.currency = 0;
         if(!this.client.requestInProgress())
         {
            this.countdownTimer.remove();
            this.ballClickDisable();
            this.crystalClicked = this.crystals[param1];
            this.client.sendRequest("/account/playFortuneGame",_loc3_);
            this.client.complete.addOnce(this.onSmallBallClickComplete);
         }
      }
      
      private function onSmallBallClickComplete(param1:Boolean, param2:*) : void
      {
         var _loc3_:XML = null;
         var _loc4_:OpenDialogSignal = null;
         if(param1)
         {
            _loc3_ = new XML(param2);
            if(this.state == STATE_ROUND_2)
            {
               new TimerCallback(0.25,this.doNova,this.crystalClicked.getCenterX(),this.crystalClicked.getCenterY(),6,65535);
               new TimerCallback(0.25,this.crystalClicked.doItemReveal,_loc3_.Awards);
               new TimerCallback(this.DISPLAY_PRIZE_TIME_2,this.resetGame);
            }
            else if(this.state == STATE_ROUND_1)
            {
               this.state = STATE_ROUND_2;
               new TimerCallback(this.DISPLAY_PRIZE_TIME_1,this.onSmallBallClickCompleteRound2,_loc3_.Awards);
               new TimerCallback(0.25,this.doNova,this.crystalClicked.getCenterX(),this.crystalClicked.getCenterY(),6,65535);
               new TimerCallback(0.25,this.crystalClicked.doItemReveal,_loc3_.Awards);
            }
            new TimerCallback(0.5,this.setString,5);
         }
         else
         {
            this.ballClickEnable(null);
            _loc4_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            if(this.state == STATE_ROUND_1)
            {
               _loc4_.dispatch(new DebugDialog("You have run out of time to choose, but an item has been chosen for you.","Oh no!"));
            }
            else
            {
               _loc4_.dispatch(new DebugDialog("You have run out of time to choose.","Oh no!"));
            }
         }
      }
      
      private function onSmallBallClickCompleteRound2(param1:int) : void
      {
         var _loc2_:int = 0;
         this.resetSpinCrystalsVars();
         this.buyButtonsEnable();
         this.buyButtonGold.setPrice(this.goldPriceSecond_,Currency.GOLD);
         this.buyButtonGold.visible = true;
         this.resetButton.visible = true;
         this.resetButton.addEventListener(MouseEvent.CLICK,this.onResetClick);
         _loc2_ = 0;
         while(_loc2_ < this.items.length)
         {
            if(int(this.items[_loc2_]) == param1)
            {
               this.items[_loc2_] = this.items[this.items.length - 1];
            }
            _loc2_++;
         }
         this.items.pop();
         _loc2_ = 0;
         while(_loc2_ < this.crystals.length)
         {
            if(this.crystals[_loc2_] != this.crystalClicked)
            {
               this.crystals[_loc2_].doItemShow(int(this.items.pop()));
            }
            _loc2_++;
         }
         this.setString(6);
      }
      
      private function resetGame() : void
      {
         this.state = STATE_ROUND_1;
         this.ballClickDisable();
         this.buyButtonsEnable();
         this.buyButtonGold.setPrice(this.goldPrice_,Currency.GOLD);
         this.buyButtonGold.visible = true;
         this.buyButtonFortune.visible = true;
         this.resetButton.visible = false;
         this.addItemSwitch();
         this.setString(0);
         this.resetSpinCrystalsVars();
         this.boughtWithGold = false;
         this.crystalMain.addEventListener(MouseEvent.ROLL_OVER,this.displayInfoHover);
         this.crystalMain.reset();
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.crystals[_loc1_].resetVars();
            _loc1_++;
         }
         this.resetBalls();
      }
      
      private function resetSpinCrystalsVars() : void
      {
         this.radius = INIT_RADIUS_FROM_MAINCRYTAL;
         this.dtBuildup = 0;
         this.direction = 8;
         this.spinSpeed = 0;
      }
      
      private function buyButtonsDisable() : void
      {
         this.buyButtonGold.removeEventListener(MouseEvent.CLICK,this.onBuyWithGoldClick);
         this.buyButtonFortune.removeEventListener(MouseEvent.CLICK,this.onBuyWithFortuneClick);
      }
      
      private function buyButtonsEnable() : void
      {
         if(this.state == STATE_ROUND_1)
         {
            this.buyButtonFortune.addEventListener(MouseEvent.CLICK,this.onBuyWithFortuneClick);
         }
         this.buyButtonGold.addEventListener(MouseEvent.CLICK,this.onBuyWithGoldClick);
      }
      
      private function ballClickDisable() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 3)
         {
            this.crystals[_loc1_].removeEventListener(MouseEvent.CLICK,this.onSmallBallClick);
            _loc1_++;
         }
      }
      
      private function ballClickEnable(param1:CrystalSmall = null) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            if(this.crystals[_loc2_] == param1)
            {
               this.crystals[_loc2_].removeEventListener(MouseEvent.CLICK,this.onSmallBallClick);
            }
            else
            {
               this.crystals[_loc2_].addEventListener(MouseEvent.CLICK,this.onSmallBallClick);
               this.crystals[_loc2_].setMouseTracking(true);
            }
            _loc2_++;
         }
      }
      
      private function resetBalls() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:int = INIT_RADIUS_FROM_MAINCRYTAL;
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = ((_loc2_ + 1) * 120 - 60) * Math.PI / 180;
            this.crystals[_loc2_].setXPos(this.crystalMain.getCenterX() + _loc1_ * Math.sin(_loc3_));
            this.crystals[_loc2_].setYPos(this.crystalMain.getCenterY() + _loc1_ * Math.cos(_loc3_));
            if(this.crystals[_loc2_].parent == null)
            {
               addChild(this.crystals[_loc2_]);
            }
            else if(this.crystals[_loc2_].visible == false)
            {
               this.crystals[_loc2_].visible = true;
            }
            this.crystals[_loc2_].removeItemReveal();
            this.crystals[_loc2_].setInactive();
            this.crystals[_loc2_].reset();
            _loc2_++;
         }
         this.crystalClicked = null;
      }
      
      private function resetBallsRound2() : void
      {
         var _loc4_:Number = NaN;
         var _loc1_:int = 0;
         var _loc2_:int = INIT_RADIUS_FROM_MAINCRYTAL;
         if(this.crystalClicked != null && Boolean(this.crystalClicked.parent))
         {
            this.crystalClicked.visible = false;
            this.crystalClicked.setInactive();
         }
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            if(this.crystals[_loc3_] != this.crystalClicked)
            {
               _loc4_ = (_loc1_ * 120 - 60) * Math.PI / 180;
               this.crystals[_loc3_].setXPos(this.crystalMain.getCenterX() + _loc2_ * Math.sin(_loc4_));
               this.crystals[_loc3_].setYPos(this.crystalMain.getCenterY() + _loc2_ * Math.cos(_loc4_));
               _loc1_++;
            }
            _loc3_++;
         }
      }
      
      public function spinCrystals() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:int = 200 * Math.abs(int(getTimer() / 2) % 1000 - 500) / 1000;
         if(this.spinSpeed < this.MAX_SPIN_SPEED)
         {
            this.spinSpeed += 4;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = ((_loc2_ + 1) * (120 + this.spinSpeed) - 60 - getTimer()) * Math.PI / 180;
            this.crystals[_loc2_].setXPos(this.crystalMain.getCenterX() + this.radius * Math.sin(_loc3_));
            this.crystals[_loc2_].setYPos(this.crystalMain.getCenterY() + this.radius * Math.cos(_loc3_));
            _loc2_++;
         }
         if(this.radius == INIT_RADIUS_FROM_MAINCRYTAL)
         {
            this.direction *= -1;
         }
         if(this.radius < 0)
         {
            this.radius = 0;
         }
         else if(this.spinSpeed == this.MAX_SPIN_SPEED)
         {
            this.radius -= this.direction * 2.85 / this.SPIN_TIME;
         }
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:int = getTimer();
         var _loc3_:int = _loc2_ - this.lastUpdate_;
         fMouseX = mouseX;
         fMouseY = mouseY;
         if(this.gameStage_ == this.GAME_STAGE_SPIN)
         {
            this.spinCrystals();
            this.crystalMain.setAnimationDuration(this.MAX_SPIN_SPEED + 80 - this.spinSpeed);
         }
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            this.crystals[_loc4_].update(_loc2_,_loc3_);
            _loc4_++;
         }
         this.rotateAroundCenter(this.platformMain,0.1);
         this.rotateAroundCenter(this.platformMainSub,-0.15);
         if(this.chooseingState)
         {
            _loc5_ = Math.random();
            if(_loc5_ < 0.05)
            {
               this.crystals[int(_loc5_ * 200 % 3)].setShake(true);
            }
         }
         this.draw(_loc2_,_loc3_);
      }
      
      public function rotateAroundCenter(param1:DisplayObject, param2:Number) : void
      {
         if(param2 < 0)
         {
            param2 *= -1;
            param1.rotation = Math.abs(param1.rotation - param2 + 360) % 360;
         }
         else
         {
            param1.rotation = (param1.rotation + param2) % 360;
         }
      }
      
      public function draw(param1:int, param2:int) : void
      {
         this.crystalMain.drawAnimation(param1,param2);
         this.particleMap.update(param1,param2);
         this.particleMap.draw(null,param1);
         this.lastUpdate_ = param1;
      }
      
      private function doNova(param1:Number, param2:Number, param3:int = 20, param4:int = 12447231) : void
      {
         var _loc5_:GameObject = null;
         var _loc6_:NovaEffect = null;
         if(this.particleMap != null)
         {
            _loc5_ = new GameObject(null);
            _loc5_.x_ = ParticleModalMap.getLocalPos(param1);
            _loc5_.y_ = ParticleModalMap.getLocalPos(param2);
            _loc6_ = new NovaEffect(_loc5_,param3,param4);
            this.particleMap.addObj(_loc6_,_loc5_.x_,_loc5_.y_);
         }
      }
      
      private function doLightning(param1:Number, param2:Number, param3:Number, param4:Number, param5:int = 200, param6:int = 12447231) : void
      {
         if(this.parent == null)
         {
            return;
         }
         var _loc7_:GameObject = new GameObject(null);
         _loc7_.x_ = ParticleModalMap.getLocalPos(param1);
         _loc7_.y_ = ParticleModalMap.getLocalPos(param2);
         var _loc8_:WorldPosData = new WorldPosData();
         _loc8_.x_ = ParticleModalMap.getLocalPos(param3);
         _loc8_.y_ = ParticleModalMap.getLocalPos(param4);
         var _loc9_:LightningEffect = new LightningEffect(_loc7_,_loc8_,param6,param5);
         this.particleMap.addObj(_loc9_,_loc7_.x_,_loc7_.y_);
      }
      
      private function setGameStage(param1:int) : void
      {
         this.gameStage_ = param1;
      }
   }
}

