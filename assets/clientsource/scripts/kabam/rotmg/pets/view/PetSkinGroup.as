package kabam.rotmg.pets.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.pets.data.PetSkinGroupVO;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.util.PetsConstants;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.PetIcon;
   import kabam.rotmg.pets.view.components.PetIconFactory;
   import kabam.rotmg.pets.view.components.slot.FeedFuseSlot;
   import kabam.rotmg.pets.view.dialogs.PetItem;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeSignal;
   
   public class PetSkinGroup extends Sprite
   {
      
      private const SPACING:uint = 55;
      
      public const initComplete:Signal = new Signal();
      
      private var rarityTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(16777215,18,true);
      
      private var upperContainer:Sprite = new Sprite();
      
      private var lowerContainer:Sprite = new Sprite();
      
      private var numUpper:uint = 0;
      
      private var numLower:uint = 0;
      
      private var petSkinGroupVO:PetSkinGroupVO;
      
      private var selectedSlot:FeedFuseSlot;
      
      private var slots:Vector.<FeedFuseSlot> = new Vector.<FeedFuseSlot>();
      
      public var skinSelected:Signal = new Signal(PetVO);
      
      public var disabled:Boolean = false;
      
      public var index:uint;
      
      public function PetSkinGroup(param1:uint)
      {
         super();
         this.index = param1;
      }
      
      public function init(param1:PetSkinGroupVO) : void
      {
         this.petSkinGroupVO = param1;
         this.rarityTextField.setStringBuilder(new LineBuilder().setParams(param1.textKey));
         this.createIconSquares();
         this.addChildren();
         this.positionChildren();
         this.initComplete.dispatch();
      }
      
      private function positionChildren() : void
      {
         this.upperContainer.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.upperContainer.width) / 2;
         this.lowerContainer.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.lowerContainer.width) / 2;
         this.lowerContainer.y = 50;
      }
      
      private function addChildren() : void
      {
         addChild(this.rarityTextField);
         addChild(this.upperContainer);
         addChild(this.lowerContainer);
      }
      
      private function createIconSquares() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:PetIcon = null;
         var _loc4_:PetItem = null;
         var _loc5_:FeedFuseSlot = null;
         var _loc6_:NativeSignal = null;
         var _loc2_:uint = this.petSkinGroupVO.icons.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.createPetIcon(this.petSkinGroupVO.icons[_loc1_],48);
            _loc4_ = new PetItem();
            _loc4_.setPetIcon(_loc3_);
            _loc5_ = new FeedFuseSlot();
            _loc5_.mouseChildren = false;
            _loc5_.setIcon(_loc4_);
            _loc6_ = new NativeSignal(_loc5_,MouseEvent.CLICK,MouseEvent);
            _loc6_.add(this.onSkinClicked);
            if(_loc1_ < 4)
            {
               this.addToUpper(_loc5_);
            }
            else
            {
               this.addToLower(_loc5_);
            }
            this.slots.push(_loc5_);
            if(this.disabled)
            {
               _loc4_.disable();
               _loc5_.mouseChildren = false;
               _loc5_.mouseEnabled = false;
            }
            _loc1_++;
         }
      }
      
      private function createPetIcon(param1:PetVO, param2:int) : PetIcon
      {
         var _loc3_:PetIconFactory = new PetIconFactory();
         var _loc4_:PetIcon = _loc3_.create(param1,param2);
         _loc4_.setTooltipEnabled(false);
         return _loc4_;
      }
      
      private function onSkinClicked(param1:MouseEvent) : void
      {
         this.skinSelected.dispatch(PetItem(param1.target.getIcon()).getPetVO());
      }
      
      private function addToUpper(param1:Sprite) : void
      {
         param1.x = this.SPACING * this.numUpper;
         this.upperContainer.addChild(param1);
         ++this.numUpper;
      }
      
      private function addToLower(param1:Sprite) : void
      {
         param1.x = this.SPACING * this.numLower;
         this.lowerContainer.addChild(param1);
         ++this.numLower;
      }
      
      public function onSlotSelected(param1:int) : void
      {
         var _loc2_:FeedFuseSlot = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < this.slots.length)
         {
            _loc2_ = FeedFuseSlot(this.slots[_loc4_]);
            _loc3_ = PetItem(_loc2_.getIcon()).getPetVO().getSkinID();
            _loc2_.highlight(_loc3_ == param1);
            _loc4_++;
         }
      }
   }
}

