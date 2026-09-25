package kabam.rotmg.classes.view
{
   import com.company.assembleegameclient.util.Currency;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkinState;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   import kabam.rotmg.util.components.RadioButton;
   import kabam.rotmg.util.components.api.BuyButton;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class CharacterSkinListItem extends Sprite
   {
      
      public static const WIDTH:int = 420;
      
      public static const PADDING:int = 16;
      
      public static const HEIGHT:int = 60;
      
      private static const HIGHLIGHTED_COLOR:uint = 8092539;
      
      private static const AVAILABLE_COLOR:uint = 5921370;
      
      private static const LOCKED_COLOR:uint = 2631720;
      
      private const grayscaleMatrix:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);
      
      private const background:Shape = this.makeBackground();
      
      private const skinContainer:Sprite = this.makeSkinContainer();
      
      private const nameText:TextFieldDisplayConcrete = this.makeNameText();
      
      private const selectionButton:RadioButton = this.makeSelectionButton();
      
      private const lock:Bitmap = this.makeLock();
      
      private const lockText:TextFieldDisplayConcrete = this.makeLockText();
      
      private const buyButtonContainer:Sprite = this.makeBuyButtonContainer();
      
      private const limitedBanner:CharacterSkinLimitedBanner = this.makeLimitedBanner();
      
      public const buy:Signal = new NativeMappedSignal(this.buyButtonContainer,MouseEvent.CLICK);
      
      public const over:Signal = new Signal();
      
      public const out:Signal = new Signal();
      
      public const selected:Signal = this.selectionButton.changed;
      
      private var model:CharacterSkin;
      
      private var state:CharacterSkinState = CharacterSkinState.NULL;
      
      private var isSelected:Boolean = false;
      
      private var skinIcon:Bitmap;
      
      private var buyButton:BuyButton;
      
      private var isOver:Boolean;
      
      public function CharacterSkinListItem()
      {
         super();
      }
      
      private function makeBackground() : Shape
      {
         var _loc1_:Shape = new Shape();
         this.drawBackground(_loc1_.graphics,WIDTH);
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeSkinContainer() : Sprite
      {
         var _loc1_:Sprite = null;
         _loc1_ = new Sprite();
         _loc1_.x = 8;
         _loc1_.y = 4;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeNameText() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setBold(true);
         _loc1_.x = 75;
         _loc1_.y = 15;
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeSelectionButton() : RadioButton
      {
         var _loc1_:RadioButton = null;
         _loc1_ = new RadioButton();
         _loc1_.setSelected(false);
         _loc1_.x = WIDTH - _loc1_.width - 15;
         _loc1_.y = HEIGHT / 2 - _loc1_.height / 2;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeLock() : Bitmap
      {
         var _loc1_:Bitmap = new Bitmap();
         _loc1_.scaleX = 2;
         _loc1_.scaleY = 2;
         _loc1_.visible = false;
         addChild(_loc1_);
         return _loc1_;
      }
      
      public function setLockIcon(param1:BitmapData) : void
      {
         this.lock.bitmapData = param1;
         this.lock.x = this.lockText.x - this.lock.width - 5;
         this.lock.y = HEIGHT / 2 - this.lock.height * 0.5;
      }
      
      private function makeLockText() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(14).setColor(16777215);
         _loc1_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeBuyButtonContainer() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.x = WIDTH - PADDING;
         _loc1_.y = HEIGHT * 0.5;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeLimitedBanner() : CharacterSkinLimitedBanner
      {
         var _loc1_:CharacterSkinLimitedBanner = null;
         _loc1_ = new CharacterSkinLimitedBanner();
         _loc1_.readyForPositioning.addOnce(this.setLimitedBannerVisibility);
         _loc1_.y = -1;
         _loc1_.visible = false;
         addChild(_loc1_);
         return _loc1_;
      }
      
      public function setBuyButton(param1:BuyButton) : void
      {
         this.buyButton = param1;
         param1.readyForPlacement.add(this.onReadyForPlacement);
         this.model && this.setCost();
         this.buyButtonContainer.addChild(param1);
         param1.x = -param1.width;
         param1.y = -param1.height * 0.5;
         this.buyButtonContainer.visible = this.state == CharacterSkinState.PURCHASABLE;
         this.setLimitedBannerVisibility();
      }
      
      private function onReadyForPlacement() : void
      {
         this.buyButton.x = -this.buyButton.width;
      }
      
      public function setSkin(param1:Bitmap) : void
      {
         this.skinIcon && this.skinContainer.removeChild(this.skinIcon);
         this.skinIcon = param1;
         this.skinIcon && this.skinContainer.addChild(this.skinIcon);
      }
      
      public function getModel() : CharacterSkin
      {
         return this.model;
      }
      
      public function setModel(param1:CharacterSkin) : void
      {
         this.model && this.model.changed.remove(this.onModelChanged);
         this.model = param1;
         this.model && this.model.changed.add(this.onModelChanged);
         this.onModelChanged(this.model);
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function onModelChanged(param1:CharacterSkin) : void
      {
         this.state = this.model ? this.model.getState() : CharacterSkinState.NULL;
         this.updateName();
         this.updateState();
         this.buyButton && this.setCost();
         this.updateUnlockText();
         this.setLimitedBannerVisibility();
         this.setIsSelected(Boolean(this.model) && this.model.getIsSelected());
      }
      
      public function getState() : CharacterSkinState
      {
         return this.state;
      }
      
      private function updateName() : void
      {
         this.nameText.setStringBuilder(new LineBuilder().setParams(this.model ? this.model.name : ""));
      }
      
      private function updateState() : void
      {
         this.setButtonVisibilities();
         this.updateBackground();
         this.setEventListeners();
         this.updateGrayFilter();
      }
      
      private function setLimitedBannerVisibility() : void
      {
         this.limitedBanner.visible = this.model && this.model.limited && this.state != CharacterSkinState.OWNED && this.state != CharacterSkinState.PURCHASING;
         this.limitedBanner.x = (this.state == CharacterSkinState.LOCKED || !this.buyButton ? this.lock.x - 5 : this.buyButtonContainer.x + this.buyButton.x - 15) - this.limitedBanner.width;
      }
      
      private function setButtonVisibilities() : void
      {
         var _loc1_:Boolean = this.state == CharacterSkinState.OWNED;
         var _loc2_:Boolean = this.state == CharacterSkinState.PURCHASABLE;
         var _loc3_:Boolean = this.state == CharacterSkinState.PURCHASING;
         var _loc4_:Boolean = this.state == CharacterSkinState.LOCKED;
         this.selectionButton.visible = _loc1_;
         this.buyButtonContainer && (this.buyButtonContainer.visible = _loc2_);
         this.lock.visible = _loc4_;
         this.lockText.visible = _loc4_ || _loc3_;
      }
      
      private function setEventListeners() : void
      {
         if(this.state == CharacterSkinState.OWNED)
         {
            this.addEventListeners();
         }
         else
         {
            this.removeEventListeners();
         }
      }
      
      private function setCost() : void
      {
         var _loc1_:int = this.model ? this.model.cost : 0;
         this.buyButton.setPrice(_loc1_,Currency.GOLD);
      }
      
      public function getIsSelected() : Boolean
      {
         return this.isSelected;
      }
      
      public function setIsSelected(param1:Boolean) : void
      {
         this.isSelected = param1 && this.state == CharacterSkinState.OWNED;
         this.selectionButton.setSelected(param1);
         this.updateBackground();
      }
      
      private function updateUnlockText() : void
      {
         if(this.model != null && this.model.unlockSpecial != null)
         {
            this.lockText.setStringBuilder(new StaticStringBuilder(this.model.unlockSpecial));
            this.lockText.setTextWidth(110);
            this.lockText.setWordWrap(true);
            this.lockText.setMultiLine(true);
            this.lockText.setAutoSize(TextFieldAutoSize.LEFT);
            this.lockText.setHorizontalAlign(TextFormatAlign.LEFT);
            this.lockText.setVerticalAlign(TextFieldAutoSize.CENTER);
            this.lockText.y = HEIGHT / 7;
         }
         else
         {
            this.lockText.setStringBuilder(this.state == CharacterSkinState.PURCHASING ? new LineBuilder().setParams(TextKey.PURCHASING_SKIN) : this.makeUnlockTextStringBuilder());
            this.lockText.y = HEIGHT / 2;
         }
         this.lockText.x = WIDTH - this.lockText.width - 15;
         this.lock.x = this.lockText.x - this.lock.width - 5;
      }
      
      private function makeUnlockTextStringBuilder() : StringBuilder
      {
         var _loc1_:LineBuilder = new LineBuilder();
         var _loc2_:String = this.model ? this.model.unlockLevel.toString() : "";
         return _loc1_.setParams(TextKey.UNLOCK_LEVEL_SKIN,{"level":_loc2_});
      }
      
      private function addEventListeners() : void
      {
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      internal function removeEventListeners() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.setIsSelected(true);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.isOver = true;
         this.updateBackground();
         this.over.dispatch();
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.isOver = false;
         this.updateBackground();
         this.out.dispatch();
      }
      
      private function updateBackground() : void
      {
         var _loc1_:ColorTransform = this.background.transform.colorTransform;
         _loc1_.color = this.getColor();
         this.background.transform.colorTransform = _loc1_;
      }
      
      private function getColor() : uint
      {
         if(this.state.isDisabled())
         {
            return LOCKED_COLOR;
         }
         if(this.isSelected || this.isOver)
         {
            return HIGHLIGHTED_COLOR;
         }
         return AVAILABLE_COLOR;
      }
      
      private function updateGrayFilter() : void
      {
         filters = this.state == CharacterSkinState.PURCHASING ? [this.grayscaleMatrix] : [];
      }
      
      public function setWidth(param1:int) : void
      {
         this.buyButtonContainer.x = param1 - PADDING;
         this.lockText.x = param1 - this.lockText.width - 15;
         this.lock.x = this.lockText.x - this.lock.width - 5;
         this.selectionButton.x = param1 - this.selectionButton.width - 15;
         this.setLimitedBannerVisibility();
         this.drawBackground(this.background.graphics,param1);
      }
      
      private function drawBackground(param1:Graphics, param2:int) : void
      {
         param1.clear();
         param1.beginFill(AVAILABLE_COLOR);
         param1.drawRect(0,0,param2,HEIGHT);
         param1.endFill();
      }
   }
}

