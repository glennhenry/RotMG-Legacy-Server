package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.SellableObject;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import com.company.assembleegameclient.ui.panels.*;
   import com.company.assembleegameclient.util.Currency;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
   import kabam.rotmg.arena.util.ArenaViewAssetFactory;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.mysterybox.components.MysteryBoxSelectModal;
   import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
   import kabam.rotmg.mysterybox.services.MysteryBoxModel;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import org.osflash.signals.Signal;
   import org.swiftsuspenders.Injector;
   
   public class MysteryBoxPanel extends Panel
   {
      
      public var buyItem:Signal = new Signal(SellableObject);
      
      private var owner_:SellableObject;
      
      private var nameText_:TextFieldDisplayConcrete;
      
      private var buyButton_:LegacyBuyButton;
      
      private var infoButton_:DeprecatedTextButton;
      
      private var icon_:Sprite;
      
      private var bitmap_:Bitmap;
      
      private const BUTTON_OFFSET:int = 17;
      
      public function MysteryBoxPanel(param1:GameSprite, param2:uint)
      {
         var _loc3_:Injector = StaticInjectorContext.getInjector();
         var _loc4_:GetMysteryBoxesTask = _loc3_.getInstance(GetMysteryBoxesTask);
         _loc4_.start();
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
         var _loc8_:MysteryBoxModel = _loc3_.getInstance(MysteryBoxModel);
         var _loc9_:Account = _loc3_.getInstance(Account);
         if(_loc8_.isInitialized() || !_loc9_.isRegistered())
         {
            this.infoButton_ = new DeprecatedTextButton(16,"MysteryBoxPanel.open");
            this.infoButton_.addEventListener(MouseEvent.CLICK,this.onInfoButtonClick);
            addChild(this.infoButton_);
         }
         else
         {
            this.infoButton_ = new DeprecatedTextButton(16,"MysteryBoxPanel.checkBackLater");
            addChild(this.infoButton_);
         }
         this.nameText_.setStringBuilder(new LineBuilder().setParams("MysteryBoxPanel.mysteryBoxShop"));
         this.bitmap_.bitmapData = ArenaViewAssetFactory.returnHostBitmap(param2).bitmapData;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
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
         this.infoButton_.removeEventListener(MouseEvent.CLICK,this.onInfoButtonClick);
      }
      
      private function onInfoButtonClick(param1:MouseEvent) : void
      {
         this.onInfoButton();
      }
      
      private function onInfoButton() : void
      {
         var _loc1_:Injector = StaticInjectorContext.getInjector();
         var _loc2_:MysteryBoxModel = _loc1_.getInstance(MysteryBoxModel);
         var _loc3_:Account = _loc1_.getInstance(Account);
         var _loc4_:OpenDialogSignal = _loc1_.getInstance(OpenDialogSignal);
         if(_loc2_.isInitialized() && _loc3_.isRegistered())
         {
            _loc4_.dispatch(new MysteryBoxSelectModal());
         }
         else if(!_loc3_.isRegistered())
         {
            _loc4_.dispatch(new RegisterPromptDialog("SellableObjectPanelMediator.text",{"type":Currency.typeToName(Currency.GOLD)}));
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Parameters.data_.interact && stage.focus == null)
         {
            this.onInfoButton();
         }
      }
      
      override public function draw() : void
      {
         this.nameText_.y = this.nameText_.height > 30 ? 0 : 12;
         this.infoButton_.x = WIDTH / 2 - this.infoButton_.width / 2;
         this.infoButton_.y = HEIGHT - this.infoButton_.height / 2 - this.BUTTON_OFFSET;
         if(!contains(this.infoButton_))
         {
            addChild(this.infoButton_);
         }
      }
   }
}

