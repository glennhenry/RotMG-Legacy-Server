package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.objects.SellableObject;
   import com.company.assembleegameclient.util.Currency;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.rotmg.fortune.components.ItemWithTooltip;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldConcreteBuilder;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import kabam.rotmg.util.components.UIAssetsHelper;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeSignal;
   
   public class ConfirmBuyModal extends Sprite
   {
      
      public static const WIDTH:int = 280;
      
      public static const HEIGHT:int = 240;
      
      public static const TEXT_MARGIN:int = 20;
      
      public static var free:Boolean = true;
      
      private const closeButton:DialogCloseButton;
      
      private const buyButton:LegacyBuyButton;
      
      private var buyButtonClicked:NativeSignal;
      
      private var quantityInputText:TextFieldDisplayConcrete;
      
      private var leftNavSprite:Sprite;
      
      private var rightNavSprite:Sprite;
      
      private var quantity_:int = 1;
      
      private var availableInventoryNumber:int;
      
      private var owner_:SellableObject;
      
      public var buyItem:Signal;
      
      public var open:Boolean;
      
      public var buttonWidth:int;
      
      public function ConfirmBuyModal(param1:Signal, param2:SellableObject, param3:Number, param4:int)
      {
         var _loc6_:TextFieldConcreteBuilder = null;
         var _loc8_:ItemWithTooltip = null;
         this.closeButton = PetsViewAssetFactory.returnCloseButton(ConfirmBuyModal.WIDTH);
         this.buyButton = new LegacyBuyButton(TextKey.SELLABLEOBJECTPANEL_BUY,16,0,Currency.INVALID);
         super();
         ConfirmBuyModal.free = false;
         this.buyItem = param1;
         this.owner_ = param2;
         this.buttonWidth = param3;
         this.availableInventoryNumber = param4;
         this.events();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.positionAndStuff();
         this.addChildren();
         this.buyButton.setPrice(this.owner_.price_,this.owner_.currency_);
         var _loc5_:String = this.owner_.soldObjectName();
         _loc6_ = new TextFieldConcreteBuilder();
         _loc6_.containerMargin = TEXT_MARGIN;
         _loc6_.containerWidth = WIDTH;
         addChild(_loc6_.getLocalizedTextObject(TextKey.BUY_CONFIRMATION_TITLE,TEXT_MARGIN,5));
         addChild(_loc6_.getLocalizedTextObject(TextKey.BUY_CONFIRMATION_DESC,TEXT_MARGIN,40));
         addChild(_loc6_.getLocalizedTextObject(_loc5_,TEXT_MARGIN,90));
         var _loc7_:* = _loc6_.getLocalizedTextObject(TextKey.BUY_CONFIRMATION_AMOUNT,TEXT_MARGIN,140);
         addChild(_loc7_);
         this.quantityInputText = _loc6_.getLiteralTextObject("1",TEXT_MARGIN,160);
         if(this.owner_.getSellableType() != -1)
         {
            _loc8_ = new ItemWithTooltip(this.owner_.getSellableType(),64);
         }
         _loc8_.x = WIDTH * 1 / 2 - _loc8_.width / 2;
         _loc8_.y = 100;
         addChild(_loc8_);
         this.quantityInputText = _loc6_.getLiteralTextObject("1",TEXT_MARGIN,160);
         this.quantityInputText.setMultiLine(false);
         addChild(this.quantityInputText);
         this.leftNavSprite = this.makeNavigator(UIAssetsHelper.LEFT_NEVIGATOR);
         this.rightNavSprite = this.makeNavigator(UIAssetsHelper.RIGHT_NEVIGATOR);
         this.leftNavSprite.x = WIDTH * 4 / 11 - this.rightNavSprite.width / 2;
         this.leftNavSprite.y = 150;
         addChild(this.leftNavSprite);
         this.rightNavSprite.x = WIDTH * 7 / 11 - this.rightNavSprite.width / 2;
         this.rightNavSprite.y = 150;
         addChild(this.rightNavSprite);
         this.refreshNavDisable();
         this.open = true;
      }
      
      private static function makeModalBackground(param1:int, param2:int) : PopupWindowBackground
      {
         var _loc3_:PopupWindowBackground = new PopupWindowBackground();
         _loc3_.draw(param1,param2);
         _loc3_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,30);
         return _loc3_;
      }
      
      private function refreshNavDisable() : *
      {
         this.leftNavSprite.alpha = this.quantity_ == 1 ? 0.5 : 1;
         this.rightNavSprite.alpha = this.quantity_ == this.availableInventoryNumber ? 0.5 : 1;
      }
      
      private function positionAndStuff() : void
      {
         this.x = -300 + -1 * ConfirmBuyModal.WIDTH * 0.5;
         this.y = -200 + -1 * ConfirmBuyModal.HEIGHT * 0.5;
         this.buyButton.x += 35;
         this.buyButton.y += 195;
         this.buyButton.x = WIDTH / 2 - this.buttonWidth / 2;
      }
      
      private function events() : void
      {
         this.closeButton.clicked.add(this.onCloseClick);
         this.buyButtonClicked = new NativeSignal(this.buyButton,MouseEvent.CLICK,MouseEvent);
         this.buyButtonClicked.add(this.onBuyClick);
      }
      
      private function addChildren() : void
      {
         addChild(makeModalBackground(ConfirmBuyModal.WIDTH,ConfirmBuyModal.HEIGHT));
         addChild(this.closeButton);
         addChild(this.buyButton);
      }
      
      public function onCloseClick() : void
      {
         this.close();
      }
      
      public function onBuyClick(param1:MouseEvent) : void
      {
         this.owner_.quantity_ = this.quantity_;
         this.buyItem.dispatch(this.owner_);
         this.close();
      }
      
      private function close() : void
      {
         parent.removeChild(this);
         ConfirmBuyModal.free = true;
         this.open = false;
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         ConfirmBuyModal.free = true;
         this.open = false;
         this.leftNavSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.rightNavSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function makeNavigator(param1:String) : Sprite
      {
         var _loc2_:* = UIAssetsHelper.createLeftNevigatorIcon(param1);
         _loc2_.addEventListener(MouseEvent.CLICK,this.onClick);
         return _loc2_;
      }
      
      private function onClick(param1:MouseEvent) : *
      {
         switch(param1.currentTarget)
         {
            case this.rightNavSprite:
               if(this.quantity_ < this.availableInventoryNumber)
               {
                  this.quantity_ += 1;
               }
               break;
            case this.leftNavSprite:
               if(this.quantity_ > 1)
               {
                  --this.quantity_;
               }
         }
         this.refreshNavDisable();
         var _loc2_:int = this.owner_.price_ * this.quantity_;
         this.buyButton.setPrice(_loc2_,this.owner_.currency_);
         this.quantityInputText.setText(this.quantity_.toString());
      }
   }
}

