package kabam.rotmg.pets.view
{
   import com.company.assembleegameclient.ui.LineBreakDesign;
   import flash.events.Event;
   import kabam.rotmg.pets.data.AbilityVO;
   import kabam.rotmg.pets.data.PetRarityEnum;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.util.FeedFuseCostModel;
   import kabam.rotmg.pets.util.PetsConstants;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.pets.view.components.FameOrGoldBuyButtons;
   import kabam.rotmg.pets.view.components.PetAbilityMeter;
   import kabam.rotmg.pets.view.components.PetFeeder;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.Signal;
   
   public class FeedPetView extends PetInteractionView
   {
      
      private const background:PopupWindowBackground = PetsViewAssetFactory.returnWindowBackground(PetsConstants.WINDOW_BACKGROUND_WIDTH,PetsConstants.WINDOW_BACKGROUND_HEIGHT);
      
      private const titleTextfield:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTopAlignedTextfield(11776947,18,true);
      
      private const buttonBar:FameOrGoldBuyButtons = PetsViewAssetFactory.returnFameOrGoldButtonBar(TextKey.PET_FEEDER_BUTTON_BAR_PREFIX,PetsConstants.WINDOW_BACKGROUND_HEIGHT - 35);
      
      private const petFeeder:PetFeeder = PetsViewAssetFactory.returnPetFeeder();
      
      private const closeButton:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(PetsConstants.WINDOW_BACKGROUND_WIDTH);
      
      private const abilityMeters:Vector.<PetAbilityMeter> = PetsViewAssetFactory.returnAbilityMeters();
      
      private const abilityMeterAnimating:Vector.<Boolean> = Vector.<Boolean>([false,false,false]);
      
      private const lineBreakDesign:LineBreakDesign = new LineBreakDesign(PetsConstants.WINDOW_BACKGROUND_WIDTH - 25,0);
      
      public const openPetPicker:Signal = new Signal();
      
      public const closed:Signal = new Signal();
      
      public var famePurchase:Signal;
      
      public var goldPurchase:Signal;
      
      public function FeedPetView()
      {
         super();
      }
      
      public function init() : void
      {
         this.titleTextfield.setStringBuilder(new LineBuilder().setParams(TextKey.PET_FEEDER_TITLE));
         this.petFeeder.openPetPicker.addOnce(this.onOpenPetPicker);
         this.famePurchase = this.buttonBar.fameButtonClicked;
         this.goldPurchase = this.buttonBar.goldButtonClicked;
         this.closeButton.clicked.add(this.onClosed);
         this.petFeeder.acceptableMatch.add(this.onAcceptableMatch);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.waitForTextChanged();
         this.addChildren();
         this.positionAssets();
      }
      
      public function resetFeed() : void
      {
         this.petFeeder.clearFood();
         this.petFeeder.updateHighlights();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.petFeeder.acceptableMatch.remove(this.onAcceptableMatch);
         this.closeButton.clicked.remove(this.onClosed);
      }
      
      private function onAcceptableMatch(param1:Boolean, param2:PetVO) : void
      {
         var _loc3_:PetRarityEnum = null;
         this.buttonBar.setDisabled(!param1);
         if(param2)
         {
            if(!param2.maxedAllAbilities())
            {
               this.buttonBar.setPrefix(TextKey.PET_FEEDER_BUTTON_BAR_PREFIX);
               _loc3_ = PetRarityEnum.selectByValue(param2.getRarity());
               this.buttonBar.setGoldPrice(FeedFuseCostModel.getFeedGoldCost(_loc3_));
               this.buttonBar.setFamePrice(FeedFuseCostModel.getFeedFameCost(_loc3_));
            }
            else
            {
               this.buttonBar.clearFameAndGold();
               this.buttonBar.setPrefix(TextKey.PET_FULLY_MAXED);
            }
         }
         else
         {
            this.buttonBar.setPrefix(TextKey.PET_SELECT_PET);
         }
      }
      
      private function onClosed() : void
      {
         this.closed.dispatch();
      }
      
      private function onOpenPetPicker() : void
      {
         this.openPetPicker.dispatch();
      }
      
      public function destroy() : void
      {
         var _loc1_:PetAbilityMeter = null;
         for each(_loc1_ in this.abilityMeters)
         {
            _loc1_.animating.remove(this.onAnimating);
         }
         this.buttonBar.positioned.remove(this.positionButtonBar);
      }
      
      public function setAbilityMeterLabels(param1:Array, param2:int) : void
      {
         var _loc4_:AbilityVO = null;
         var _loc5_:PetAbilityMeter = null;
         var _loc6_:PetAbilityMeter = null;
         var _loc3_:int = 0;
         if(param1 == null)
         {
            for each(_loc5_ in this.abilityMeters)
            {
               _loc5_.visible = false;
            }
         }
         for each(_loc4_ in param1)
         {
            if(_loc3_ < this.abilityMeters.length)
            {
               _loc6_ = this.abilityMeters[_loc3_];
               _loc6_.index = _loc3_;
               _loc6_.max = param2;
               _loc6_.visible = true;
               _loc6_.initializeData(_loc4_);
               _loc6_.animating.add(this.onAnimating);
               _loc3_++;
            }
         }
      }
      
      private function onAnimating(param1:PetAbilityMeter, param2:Boolean) : void
      {
         this.abilityMeterAnimating[param1.index] = param2;
         var _loc3_:Boolean = this.hasAnimatingBars();
         this.buttonBar.setDisabled(_loc3_);
         this.petFeeder.setProcessing(_loc3_);
         !_loc3_ && this.petFeeder.clearFood();
      }
      
      private function hasAnimatingBars() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc1_:Boolean = false;
         for each(_loc2_ in this.abilityMeterAnimating)
         {
            if(_loc2_)
            {
               _loc1_ = true;
               break;
            }
         }
         return _loc1_;
      }
      
      private function addChildren() : void
      {
         var _loc1_:PetAbilityMeter = null;
         addChild(this.background);
         addChild(this.titleTextfield);
         addChild(this.buttonBar);
         addChild(this.petFeeder);
         addChild(this.closeButton);
         addChild(this.lineBreakDesign);
         for each(_loc1_ in this.abilityMeters)
         {
            _loc1_.visible = false;
            addChild(_loc1_);
         }
      }
      
      private function positionAssets() : void
      {
         positionThis();
         this.positionLinebreak();
         this.positionPetFeeder();
      }
      
      private function positionPetFeeder() : void
      {
         this.petFeeder.x = Math.round((PetsConstants.WINDOW_BACKGROUND_WIDTH - this.petFeeder.width) * 0.5);
      }
      
      private function waitForTextChanged() : void
      {
         var _loc2_:PetAbilityMeter = null;
         this.titleTextfield.textChanged.addOnce(this.positionTextField);
         var _loc1_:SignalWaiter = new SignalWaiter();
         for each(_loc2_ in this.abilityMeters)
         {
            _loc1_.push(_loc2_.positioned);
         }
         _loc1_.complete.addOnce(this.positionMeters);
         this.buttonBar.positioned.add(this.positionButtonBar);
      }
      
      private function positionTextField() : void
      {
         this.titleTextfield.y = 5;
         this.titleTextfield.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.titleTextfield.width) * 0.5;
      }
      
      private function positionMeters() : void
      {
         var _loc2_:PetAbilityMeter = null;
         var _loc1_:int = this.lineBreakDesign.y + 14;
         for each(_loc2_ in this.abilityMeters)
         {
            _loc2_.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - 227) * 0.5;
            _loc2_.y = _loc1_;
            _loc1_ += _loc2_.height + 10;
         }
      }
      
      private function positionLinebreak() : void
      {
         this.lineBreakDesign.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.lineBreakDesign.width + 8) * 0.5;
         this.lineBreakDesign.y = 152;
      }
      
      private function positionButtonBar() : void
      {
         this.buttonBar.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.buttonBar.width) / 2;
      }
   }
}

