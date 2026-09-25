package kabam.rotmg.questrewards.view
{
   import com.company.assembleegameclient.map.ParticleModalMap;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.util.Currency;
   import com.gskinner.motion.GTween;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import kabam.display.Loader.LoaderProxy;
   import kabam.display.Loader.LoaderProxyConcrete;
   import kabam.rotmg.account.core.view.EmptyFrame;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.questrewards.components.ModalItemSlot;
   import kabam.rotmg.text.model.FontModel;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import org.osflash.signals.Signal;
   
   public class QuestRewardsView extends EmptyFrame
   {
      
      public static const closed:Signal = new Signal();
      
      public static var backgroundImageEmbed:Class = QuestRewardsView_backgroundImageEmbed;
      
      public static var questCompleteBanner:Class = QuestRewardsView_questCompleteBanner;
      
      public static var dailyQuestBanner:Class = QuestRewardsView_dailyQuestBanner;
      
      public static var rewardgranted:Class = QuestRewardsView_rewardgranted;
      
      public static const MODAL_WIDTH:int = 600;
      
      public static const MODAL_HEIGHT:int = 600;
      
      private var rightSlot:ModalItemSlot;
      
      private var prevSlot:ModalItemSlot;
      
      private var nextSlot:ModalItemSlot;
      
      public var exchangeButton:LegacyBuyButton = new LegacyBuyButton("Turn in!",36,0,Currency.INVALID,true);
      
      private var infoImageLoader:LoaderProxy = new LoaderProxyConcrete();
      
      private var infoImage:DisplayObject;
      
      private var leftCenter:int = -1;
      
      private var dqbanner:DisplayObject;
      
      public function QuestRewardsView()
      {
         super(MODAL_WIDTH,MODAL_HEIGHT);
         this.rightSlot = new ModalItemSlot(true,true);
         this.rightSlot.hideOuterSlot(false);
         this.prevSlot = new ModalItemSlot();
         this.prevSlot.hideOuterSlot(true);
         this.nextSlot = new ModalItemSlot();
         this.nextSlot.hideOuterSlot(true);
      }
      
      public function init(param1:int, param2:int, param3:String, param4:String) : void
      {
         var _loc7_:TextField = null;
         var _loc10_:TextFormat = null;
         var _loc5_:String = "Tier " + param1.toString();
         setTitle(_loc5_,true);
         this.dqbanner = new dailyQuestBanner();
         addChild(this.dqbanner);
         this.dqbanner.x = modalWidth / 4 * 1.1 - this.dqbanner.width / 2;
         this.dqbanner.y = modalHeight / 20 + 2;
         this.leftCenter = this.dqbanner.x + this.dqbanner.width / 2;
         title.setSize(20);
         title.setColor(16689154);
         title.x = modalWidth / 4 * 1.1 - title.width / 2;
         title.y = this.dqbanner.y + this.dqbanner.height + 5;
         title.setBold(false);
         if(title.textField != null)
         {
            _loc10_ = title.getTextFormat(0,_loc5_.length);
            _loc10_.leading = 10;
            title.setTextFormat(_loc10_,0,_loc5_.length);
         }
         var _loc6_:TextFormat = new TextFormat();
         _loc6_.size = 13;
         _loc6_.font = "Myraid Pro";
         _loc6_.align = TextFormatAlign.CENTER;
         _loc7_ = new TextField();
         _loc7_.defaultTextFormat = _loc6_;
         _loc7_.text = "All Quests refresh daily at 5pm Pacific Time";
         _loc7_.wordWrap = true;
         _loc7_.width = 600;
         _loc7_.height = 200;
         _loc7_.y = 554;
         _loc7_.textColor = 16689154;
         _loc7_.alpha = 0.8;
         _loc7_.selectable = false;
         addChild(_loc7_);
         var _loc8_:String = LineBuilder.getLocalizedStringFromKey(ObjectLibrary.typeToDisplayId_[param2]);
         this.constructDescription(param3,_loc8_);
         this.addCloseButton();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addChild(this.rightSlot);
         addChild(this.prevSlot);
         this.prevSlot.setCheckMark();
         if(param1 == 1)
         {
            this.prevSlot.visible = false;
         }
         addChild(this.nextSlot);
         this.nextSlot.setQuestionMark();
         this.rightSlot.setUsageText("Drag the item from your inventory into the slot",14,65535);
         this.rightSlot.setActionButton(this.exchangeButton);
         addChild(this.exchangeButton);
         this.exchangeButton.setText("Turn in!");
         this.exchangeButton.scaleButtonWidth(1.3);
         this.exchangeButton.scaleButtonHeight(2.4);
         var _loc9_:BitmapData = ObjectLibrary.getRedrawnTextureFromType(param2,80,true,false);
         this.rightSlot.setEmbeddedImage(new Bitmap(_loc9_));
         this.infoImageLoader && this.infoImageLoader.unload();
         this.infoImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onRewardLoadComplete);
         this.infoImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onRewardLoadError);
         this.infoImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR,this.onRewardLoadError);
         this.infoImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onRewardLoadError);
         this.infoImageLoader.load(new URLRequest(param4));
         this.positionAssets();
      }
      
      private function positionAssets() : void
      {
         this.rightSlot.x = this.leftCenter - this.rightSlot.width / 2;
         this.rightSlot.y = 350;
         this.prevSlot.width *= 0.8;
         this.prevSlot.height *= 0.8;
         this.prevSlot.x = this.rightSlot.x - this.prevSlot.width;
         this.prevSlot.y = this.rightSlot.y + (82 - this.prevSlot.height) / 2;
         this.nextSlot.width *= 0.8;
         this.nextSlot.height *= 0.8;
         this.nextSlot.x = this.rightSlot.x + this.rightSlot.width;
         this.nextSlot.y = this.rightSlot.y + (82 - this.nextSlot.height) / 2;
         this.exchangeButton.x = this.leftCenter - this.exchangeButton.width / 2;
         this.exchangeButton.y = this.rightSlot.y + 100;
         this.exchangeButton.height = 50;
         background = this.makeModalBackground();
      }
      
      private function addInfoImageChild() : void
      {
         if(this.infoImage == null)
         {
            return;
         }
         this.infoImage.alpha = 0;
         addChild(this.infoImage);
         this.infoImage.x = desc.x + desc.width + 1;
         this.infoImage.y = modalHeight / 20;
         var _loc2_:Shape = new Shape();
         var _loc3_:Graphics = _loc2_.graphics;
         _loc3_.beginFill(0);
         _loc3_.drawRect(0,0,600,550);
         _loc3_.endFill();
         addChild(_loc2_);
         this.infoImage.mask = _loc2_;
         new GTween(this.infoImage,1.25,{"alpha":1});
      }
      
      private function onRewardLoadComplete(param1:Event) : void
      {
         this.infoImageLoader.removeEventListener(Event.COMPLETE,this.onRewardLoadComplete);
         this.infoImageLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onRewardLoadError);
         this.infoImageLoader.removeEventListener(IOErrorEvent.DISK_ERROR,this.onRewardLoadError);
         this.infoImageLoader.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onRewardLoadError);
         if(this.infoImage != null && this.infoImage.parent != null)
         {
            removeChild(this.infoImage);
         }
         this.infoImage = DisplayObject(this.infoImageLoader);
         this.addInfoImageChild();
      }
      
      private function onRewardLoadError(param1:IOErrorEvent) : void
      {
         this.infoImageLoader.removeEventListener(Event.COMPLETE,this.onRewardLoadComplete);
         this.infoImageLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onRewardLoadError);
         this.infoImageLoader.removeEventListener(IOErrorEvent.DISK_ERROR,this.onRewardLoadError);
         this.infoImageLoader.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onRewardLoadError);
      }
      
      public function getItemSlot() : ModalItemSlot
      {
         return this.rightSlot;
      }
      
      public function getExchangeButton() : LegacyBuyButton
      {
         return this.exchangeButton;
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         closeButton.clicked.remove(this.onClosed);
      }
      
      private function onClosed() : void
      {
         closed.dispatch();
      }
      
      override protected function makeModalBackground() : Sprite
      {
         x = 0;
         var _loc1_:Sprite = new Sprite();
         var _loc2_:DisplayObject = new backgroundImageEmbed();
         _loc2_.width = modalWidth;
         _loc2_.height = modalHeight;
         _loc2_.alpha = 0.74;
         _loc1_.addChild(_loc2_);
         return _loc1_;
      }
      
      private function addCloseButton() : void
      {
         var _loc1_:DialogCloseButton = new DialogCloseButton(0.82);
         addChild(_loc1_);
         _loc1_.y = 4;
         _loc1_.x = modalWidth - _loc1_.width - 5;
         _loc1_.clicked.add(this.onClosed);
         closeButton = _loc1_;
      }
      
      public function noNewQuests() : void
      {
         this.addCloseButton();
         var _loc1_:TextField = new TextField();
         var _loc2_:String = "ALL QUESTS COMPLETED!";
         var _loc3_:String = "";
         _loc1_.text = _loc2_ + "\n\n\n\n" + _loc3_;
         _loc1_.width = 600;
         var _loc4_:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
         var _loc5_:TextFormat = _loc4_.apply(_loc1_,32,16777215,true,true);
         _loc1_.selectable = false;
         _loc1_.x = 0;
         _loc1_.y = 150;
         _loc1_.embedFonts = true;
         _loc1_.filters = [new GlowFilter(49941)];
         addChild(new ParticleModalMap(1));
         addChild(_loc1_);
         _loc1_ = new TextField();
         _loc2_ = "";
         _loc3_ = "Return at 5pm Pacific Time for New Quests!";
         _loc1_.text = _loc2_ + "\n\n\n" + _loc3_;
         _loc1_.width = 600;
         _loc4_.apply(_loc1_,17,49941,false,true);
         _loc1_.selectable = false;
         _loc1_.x = 0;
         _loc1_.y = 150;
         _loc1_.embedFonts = true;
         _loc1_.filters = [new DropShadowFilter(0,0,0)];
         addChild(_loc1_);
      }
      
      public function constructDescription(param1:String, param2:String = "") : void
      {
         var _loc4_:String = null;
         var _loc6_:TextFormat = null;
         var _loc3_:int = param1.indexOf("{goal}");
         if(_loc3_ != -1)
         {
            _loc4_ = param1.split("{goal}").join(param2);
            setDesc(_loc4_,true);
         }
         else
         {
            _loc4_ = param1;
         }
         setDesc(_loc4_,true);
         desc.setColor(16689154);
         desc.setBold(false);
         desc.setSize(15);
         desc.setTextWidth(315);
         desc.x = modalWidth / 4 * 1.1 - desc.width / 2 + 3;
         desc.y = title != null ? title.y + title.height + 6 : 165;
         desc.setAutoSize(TextFieldAutoSize.LEFT);
         desc.setHorizontalAlign("left");
         desc.filters = [new DropShadowFilter(0,0,0)];
         desc.setLeftMargin(14);
         var _loc5_:TextFormat = desc.getTextFormat(0,_loc4_.length);
         _loc5_.leading = 4;
         desc.setTextFormat(_loc5_,0,_loc4_.length);
         if(_loc3_ != -1)
         {
            _loc6_ = desc.getTextFormat(_loc3_,_loc3_ + param2.length);
            _loc6_.color = 196098;
            _loc6_.bold = true;
            desc.setTextFormat(_loc6_,_loc3_,_loc3_ + param2.length);
         }
      }
      
      public function onQuestComplete() : void
      {
         var _loc1_:DisplayObject = new questCompleteBanner();
         _loc1_.x = 120;
         _loc1_.y = 180;
         _loc1_.scaleX = 0.1;
         _loc1_.scaleY = 0.1;
         new GTween(_loc1_,0.4,{
            "alpha":1,
            "scaleX":0.6,
            "scaleY":0.6,
            "x":30,
            "y":130
         });
         addChild(_loc1_);
         var _loc2_:DisplayObject = new rewardgranted();
         _loc2_.x = this.infoImage.x + 4;
         _loc2_.y = this.infoImage.y + 4;
         _loc2_.alpha = 0;
         addChild(_loc2_);
         new GTween(_loc2_,0.4,{"alpha":1});
         new GTween(desc,0.4,{"alpha":0.2});
         new GTween(this.dqbanner,0.4,{"alpha":0.2});
         new GTween(title,0.4,{"alpha":0.2});
         this.rightSlot.highLightAll(5526612);
         this.rightSlot.stopOutLineAnimation();
      }
      
      public function onExchangeClick() : void
      {
         this.rightSlot.playOutLineAnimation(-1);
      }
   }
}

