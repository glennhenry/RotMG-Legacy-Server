package kabam.rotmg.pets.view.components
{
   import flash.display.Sprite;
   import kabam.rotmg.pets.data.PetSlotsState;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.slot.FoodFeedFuseSlot;
   import kabam.rotmg.pets.view.components.slot.PetFeedFuseSlot;
   import org.osflash.signals.Signal;
   
   public class PetFeeder extends Sprite
   {
      
      public const openPetPicker:Signal = new Signal();
      
      public const acceptableMatch:Signal = new Signal(Boolean,PetVO);
      
      public const petLoaded:Signal = new Signal(PetVO);
      
      private var leftSlot:PetFeedFuseSlot = new PetFeedFuseSlot();
      
      private var arrow:FeedFuseArrow = PetsViewAssetFactory.returnPetFeederArrow();
      
      private var rightSlot:FoodFeedFuseSlot = PetsViewAssetFactory.returnPetFeederRightSlot();
      
      private var state:PetSlotsState;
      
      public function PetFeeder()
      {
         super();
         addChild(this.leftSlot);
         addChild(this.arrow);
         addChild(this.rightSlot);
         this.leftSlot.openPetPicker.addOnce(this.onOpenPetPicker);
         this.rightSlot.foodLoaded.add(this.onFoodLoaded);
         this.rightSlot.foodUnloaded.add(this.onFoodUnloaded);
      }
      
      public function initialize(param1:PetSlotsState) : void
      {
         this.state = param1;
         this.setPet(this.state.leftSlotPetVO);
         this.update();
      }
      
      public function setPet(param1:PetVO) : void
      {
         this.leftSlot.setPet(param1);
         if(param1)
         {
            this.petLoaded.dispatch(param1);
         }
      }
      
      public function clearFood() : void
      {
         this.state.rightSlotItemId = -1;
         this.state.rightSlotOwnerId = -1;
         this.state.rightSlotId = -1;
         this.rightSlot.clearItem();
         this.update();
      }
      
      private function onFoodUnloaded() : void
      {
         this.state.rightSlotItemId = -1;
         this.state.rightSlotOwnerId = -1;
         this.state.rightSlotId = -1;
         this.update();
      }
      
      private function onFoodLoaded(param1:int) : void
      {
         this.state.rightSlotItemId = param1;
         this.update();
      }
      
      private function update() : void
      {
         this.updateHighlights();
         this.acceptableMatch.dispatch(this.state.isAcceptableFeedState(),this.state.leftSlotPetVO);
      }
      
      private function onOpenPetPicker() : void
      {
         this.openPetPicker.dispatch();
      }
      
      public function updateHighlights() : void
      {
         if(this.state.isAcceptableFeedState())
         {
            this.arrow.highlight(true);
            this.rightSlot.highlight(true);
            this.leftSlot.highlight(true);
         }
         else
         {
            this.rightSlot.highlight(this.state.rightSlotItemId == -1);
            this.leftSlot.highlight(this.state.leftSlotPetVO == null);
            this.arrow.highlight(false);
         }
      }
      
      public function setProcessing(param1:Boolean) : void
      {
         this.rightSlot.setProcessing(param1);
         this.leftSlot.setProcessing(param1);
         if(param1)
         {
            this.arrow.highlight(false);
            this.rightSlot.highlight(false);
            this.leftSlot.highlight(false);
         }
         else
         {
            this.update();
         }
      }
   }
}

