package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Merchant;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.objects.SellableObject;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.ConfirmBuyModal;
   import com.company.assembleegameclient.ui.RankText;
   import com.company.assembleegameclient.ui.panels.*;
   import com.company.assembleegameclient.util.Currency;
   import com.company.assembleegameclient.util.GuildUtil;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import kabam.rotmg.tooltips.TooltipAble;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import org.osflash.signals.Signal;
   
   public class SellableObjectPanel extends Panel implements TooltipAble
   {
      
      public var hoverTooltipDelegate:HoverTooltipDelegate = new HoverTooltipDelegate();
      
      public var buyItem:Signal = new Signal(SellableObject);
      
      private var owner_:SellableObject;
      
      private var nameText_:TextFieldDisplayConcrete;
      
      private var buyButton_:LegacyBuyButton;
      
      private var rankReqText_:Sprite;
      
      private var guildRankReqText_:TextFieldDisplayConcrete;
      
      private var icon_:Sprite;
      
      private var bitmap_:Bitmap;
      
      private var confirmBuyModal:ConfirmBuyModal;
      
      private var availableInventoryNumber:int;
      
      private const BUTTON_OFFSET:int = 17;
      
      public function SellableObjectPanel(param1:GameSprite, param2:SellableObject)
      {
         super(param1);
         this.nameText_ = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(WIDTH - 44);
         this.nameText_.setBold(true);
         this.nameText_.setStringBuilder(new LineBuilder().setParams(TextKey.SELLABLEOBJECTPANEL_TEXT));
         this.nameText_.setWordWrap(true);
         this.nameText_.setMultiLine(true);
         this.nameText_.setAutoSize(TextFieldAutoSize.CENTER);
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         this.icon_ = new Sprite();
         addChild(this.icon_);
         this.bitmap_ = new Bitmap(null);
         this.icon_.addChild(this.bitmap_);
         this.buyButton_ = new LegacyBuyButton(TextKey.SELLABLEOBJECTPANEL_BUY,16,0,Currency.INVALID);
         this.buyButton_.addEventListener(MouseEvent.CLICK,this.onBuyButtonClick);
         addChild(this.buyButton_);
         this.setOwner(param2);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.hoverTooltipDelegate.setDisplayObject(this);
         this.hoverTooltipDelegate.tooltip = param2.getTooltip();
      }
      
      private static function createRankReqText(param1:int) : Sprite
      {
         var requiredText:TextFieldDisplayConcrete = null;
         var rankText:Sprite = null;
         var rankReq:int = param1;
         var rankReqText:Sprite = new Sprite();
         requiredText = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         requiredText.filters = [new DropShadowFilter(0,0,0)];
         rankReqText.addChild(requiredText);
         rankText = new RankText(rankReq,false,false);
         rankReqText.addChild(rankText);
         requiredText.textChanged.addOnce(function():void
         {
            rankText.x = requiredText.width * 0.5 + 4;
            rankText.y = -rankText.height / 2;
         });
         requiredText.setStringBuilder(new LineBuilder().setParams(TextKey.SELLABLE_OBJECT_PANEL_RANK_REQUIRED));
         return rankReqText;
      }
      
      private static function createGuildRankReqText(param1:int) : TextFieldDisplayConcrete
      {
         var _loc2_:TextFieldDisplayConcrete = null;
         _loc2_ = new TextFieldDisplayConcrete().setSize(16).setColor(16711680).setBold(true).setAutoSize(TextFieldAutoSize.CENTER);
         var _loc3_:String = GuildUtil.rankToString(param1);
         _loc2_.setStringBuilder(new LineBuilder().setParams(TextKey.SELLABLE_OBJECT_PANEL_GUILD_RANK,{"amount":_loc3_}));
         _loc2_.filters = [new DropShadowFilter(0,0,0)];
         return _loc2_;
      }
      
      public function setOwner(param1:SellableObject) : void
      {
         if(param1 == this.owner_)
         {
            return;
         }
         this.owner_ = param1;
         this.buyButton_.setPrice(this.owner_.price_,this.owner_.currency_);
         var _loc2_:String = this.owner_.soldObjectName();
         this.nameText_.setStringBuilder(new LineBuilder().setParams(_loc2_));
         this.bitmap_.bitmapData = this.owner_.getIcon();
      }
      
      public function setInventorySpaceAmount(param1:int) : void
      {
         this.availableInventoryNumber = param1;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.icon_.x = -4;
         this.icon_.y = -8;
         this.nameText_.x = 44;
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         if(parent != null && this.confirmBuyModal != null && this.confirmBuyModal.open)
         {
            parent.removeChild(this.confirmBuyModal);
         }
      }
      
      private function onBuyButtonClick(param1:MouseEvent) : void
      {
         if(ConfirmBuyModal.free)
         {
            this.buyEvent();
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Parameters.data_.interact && stage.focus == null && ConfirmBuyModal.free)
         {
            this.buyEvent();
         }
      }
      
      private function buyEvent() : void
      {
         var _loc1_:Account = StaticInjectorContext.getInjector().getInstance(Account);
         if(parent != null && _loc1_.isRegistered() && this.owner_ is Merchant)
         {
            this.confirmBuyModal = new ConfirmBuyModal(this.buyItem,this.owner_,this.buyButton_.width,this.availableInventoryNumber);
            parent.addChild(this.confirmBuyModal);
         }
         else
         {
            this.buyItem.dispatch(this.owner_);
         }
      }
      
      override public function draw() : void
      {
         var _loc1_:Player = gs_.map.player_;
         this.nameText_.y = this.nameText_.height > 30 ? 0 : 12;
         var _loc2_:int = this.owner_.rankReq_;
         if(_loc1_.numStars_ < _loc2_)
         {
            if(contains(this.buyButton_))
            {
               removeChild(this.buyButton_);
            }
            if(this.rankReqText_ == null || !contains(this.rankReqText_))
            {
               this.rankReqText_ = createRankReqText(_loc2_);
               this.rankReqText_.x = WIDTH / 2 - this.rankReqText_.width / 2;
               this.rankReqText_.y = HEIGHT - this.rankReqText_.height / 2 - 20;
               addChild(this.rankReqText_);
            }
         }
         else if(_loc1_.guildRank_ < this.owner_.guildRankReq_)
         {
            if(contains(this.buyButton_))
            {
               removeChild(this.buyButton_);
            }
            if(this.guildRankReqText_ == null || !contains(this.guildRankReqText_))
            {
               this.guildRankReqText_ = createGuildRankReqText(this.owner_.guildRankReq_);
               this.guildRankReqText_.x = WIDTH / 2 - this.guildRankReqText_.width / 2;
               this.guildRankReqText_.y = HEIGHT - this.guildRankReqText_.height / 2 - 20;
               addChild(this.guildRankReqText_);
            }
         }
         else
         {
            this.buyButton_.setPrice(this.owner_.price_,this.owner_.currency_);
            this.buyButton_.setEnabled(gs_.gsc_.outstandingBuy_ == null);
            this.buyButton_.x = WIDTH / 2 - this.buyButton_.width / 2;
            this.buyButton_.y = HEIGHT - this.buyButton_.height / 2 - this.BUTTON_OFFSET;
            if(!contains(this.buyButton_))
            {
               addChild(this.buyButton_);
            }
            if(this.rankReqText_ != null && contains(this.rankReqText_))
            {
               removeChild(this.rankReqText_);
            }
         }
      }
      
      public function setShowToolTipSignal(param1:ShowTooltipSignal) : void
      {
         this.hoverTooltipDelegate.setShowToolTipSignal(param1);
      }
      
      public function getShowToolTip() : ShowTooltipSignal
      {
         return this.hoverTooltipDelegate.getShowToolTip();
      }
      
      public function setHideToolTipsSignal(param1:HideTooltipsSignal) : void
      {
         this.hoverTooltipDelegate.setHideToolTipsSignal(param1);
      }
      
      public function getHideToolTips() : HideTooltipsSignal
      {
         return this.hoverTooltipDelegate.getHideToolTips();
      }
   }
}

