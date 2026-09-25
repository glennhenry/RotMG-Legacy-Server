package kabam.rotmg.pets.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.pets.data.YardUpgraderVO;
   import kabam.rotmg.pets.util.PetsConstants;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.pets.view.components.FameOrGoldBuyButtons;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.Signal;
   
   public class YardUpgraderView extends Sprite
   {
      
      private var PetYardImage:Class = YardUpgraderView_PetYardImage;
      
      private const background:PopupWindowBackground = PetsViewAssetFactory.returnYardUpgradeWindowBackground(PetsConstants.WINDOW_BACKGROUND_WIDTH,392);
      
      private const titleTextfield:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(16777215,18,true);
      
      private const upgradeTextfield:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(11776947,13,false);
      
      private const rarityTextfield:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(16777103,16,true);
      
      private const buttonBar:FameOrGoldBuyButtons = PetsViewAssetFactory.returnFameOrGoldButtonBar("YardUpgraderView.upgrade",357);
      
      private const closeButton:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(PetsConstants.WINDOW_BACKGROUND_WIDTH);
      
      private const petYardImage:DisplayObject = new this.PetYardImage();
      
      private const currentMaxBox:StatusBox = new StatusBox();
      
      public const closed:Signal = new Signal();
      
      public var famePurchase:Signal;
      
      public var goldPurchase:Signal;
      
      private var vo:YardUpgraderVO;
      
      public function YardUpgraderView()
      {
         super();
      }
      
      public function init(param1:YardUpgraderVO) : void
      {
         this.vo = param1;
         this.closeButton.clicked.add(this.onClosed);
         this.handlePurchaseButtons();
         this.setTextValues();
         this.waitForTextChanged();
         this.addChildren();
         this.positionAssets();
      }
      
      private function handlePurchaseButtons() : void
      {
         this.famePurchase = this.buttonBar.fameButtonClicked;
         this.goldPurchase = this.buttonBar.goldButtonClicked;
         this.buttonBar.setFamePrice(this.vo.famePrice);
         this.buttonBar.setGoldPrice(this.vo.goldPrice);
      }
      
      private function setTextValues() : void
      {
         this.titleTextfield.setStringBuilder(new LineBuilder().setParams("YardUpgraderView.title"));
         this.rarityTextfield.setStringBuilder(new LineBuilder().setParams(this.wrapInBraces(this.vo.nextRarityLevel)));
         this.upgradeTextfield.setStringBuilder(new LineBuilder().setParams("YardUpgraderView.info"));
         this.upgradeTextfield.setTextWidth(PetsConstants.WINDOW_BACKGROUND_WIDTH - 40).setWordWrap(true).setHorizontalAlign(TextFormatAlign.CENTER);
         this.currentMaxBox.updateTextfields("YardUpgraderView.currentMax",this.wrapInBraces(this.vo.currentRarityLevel));
      }
      
      private function wrapInBraces(param1:String) : String
      {
         return "{" + param1 + "}";
      }
      
      private function onClosed() : void
      {
         this.closed.dispatch();
      }
      
      public function destroy() : void
      {
         this.buttonBar.positioned.remove(this.positionButtonBar);
      }
      
      public function setFeedGoldCost(param1:int) : void
      {
         this.buttonBar.setGoldPrice(param1);
      }
      
      public function setFeedFameCost(param1:int) : void
      {
         this.buttonBar.setFamePrice(param1);
      }
      
      private function onAnimating(param1:Boolean) : void
      {
         this.closeButton.disabled = param1;
         this.buttonBar.setDisabled(param1);
      }
      
      private function addChildren() : void
      {
         this.petYardImage.y = 31;
         addChild(this.background);
         addChild(this.titleTextfield);
         addChild(this.rarityTextfield);
         addChild(this.upgradeTextfield);
         addChild(this.buttonBar);
         addChild(this.closeButton);
         addChild(this.petYardImage);
         addChild(this.currentMaxBox);
      }
      
      private function positionAssets() : void
      {
         this.positionThis();
         this.petYardImage.y = 30;
         this.currentMaxBox.x = 11;
         this.currentMaxBox.y = 300;
      }
      
      private function positionThis() : void
      {
         this.x = (stage.stageWidth - this.width) * 0.5;
         this.y = (stage.stageHeight - this.height) * 0.5;
      }
      
      private function waitForTextChanged() : void
      {
         var _loc1_:SignalWaiter = new SignalWaiter();
         _loc1_.push(this.titleTextfield.textChanged);
         _loc1_.push(this.upgradeTextfield.textChanged);
         _loc1_.push(this.rarityTextfield.textChanged);
         _loc1_.complete.addOnce(this.positionTextField);
         this.buttonBar.positioned.add(this.positionButtonBar);
      }
      
      private function positionTextField() : void
      {
         this.titleTextfield.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.titleTextfield.width) * 0.5;
         this.upgradeTextfield.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.upgradeTextfield.width) * 0.5;
         this.rarityTextfield.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.rarityTextfield.width) * 0.5;
         this.titleTextfield.y = 20;
         this.upgradeTextfield.y = 229;
         this.rarityTextfield.y = 269;
      }
      
      private function positionButtonBar() : void
      {
         this.buttonBar.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.buttonBar.width) / 2;
      }
   }
}

