package kabam.rotmg.pets.view
{
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import com.company.assembleegameclient.ui.dialogs.DialogCloser;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.lib.ui.api.Size;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.data.ReskinViewState;
   import kabam.rotmg.pets.util.PetsConstants;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.pets.view.dialogs.PetPicker;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeSignal;
   
   public class PetFormView extends PetInteractionView implements DialogCloser
   {
      
      private static const closeDialogSignal:Signal = new Signal();
      
      private const background:PopupWindowBackground = PetsViewAssetFactory.returnFuserWindowBackground();
      
      private const titleTextfield:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTopAlignedTextfield(11776947,18,true);
      
      private const closeButton:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(PetsConstants.WINDOW_BACKGROUND_WIDTH);
      
      private const NUM_CATEGORIES:int = 3;
      
      public const closed:Signal = new Signal();
      
      public const skinGroupsInitialized:Signal = new Signal();
      
      public const reskinRequest:Signal = new Signal();
      
      private var petPickerContainer:Sprite = new Sprite();
      
      private var reskinContainer:Sprite = new Sprite();
      
      private var skinGroups:Vector.<PetSkinGroup>;
      
      private var posY:uint = 60;
      
      public var reskinButton:DeprecatedTextButton = new DeprecatedTextButton(14,TextKey.PET_RESKIN_BUTTON_CHOOSE);
      
      public var reskinButtonClick:NativeSignal = new NativeSignal(this.reskinButton,MouseEvent.CLICK);
      
      public var skinGroupInitCount:uint = 0;
      
      public function PetFormView()
      {
         super();
      }
      
      public function init() : void
      {
         this.titleTextfield.setStringBuilder(new LineBuilder().setParams(TextKey.PET_RESKIN_TITLE));
         this.closeButton.clicked.add(this.onClose);
         this.reskinButtonClick.add(this.onReskinClick);
         this.reskinButton.textChanged.add(this.positionReskinButton);
         this.waitForTextChanged();
         this.addChildren();
         this.positionAssets();
      }
      
      private function onReskinClick(param1:MouseEvent) : void
      {
         this.reskinRequest.dispatch();
      }
      
      public function createSkinGroups(param1:Vector.<PetSkinGroup>) : void
      {
         var _loc2_:PetSkinGroup = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.NUM_CATEGORIES)
         {
            _loc2_ = param1[_loc3_];
            this.skinGroups = param1;
            param1[_loc3_].initComplete.add(this.onSkinGroupInit);
            this.reskinContainer.addChild(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      public function onSkinGroupInit() : *
      {
         ++this.skinGroupInitCount;
         if(this.skinGroupInitCount == this.NUM_CATEGORIES)
         {
            this.positionSkinGroups();
            this.skinGroupsInitialized.dispatch();
         }
      }
      
      private function positionSkinGroups() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.NUM_CATEGORIES)
         {
            this.skinGroups[_loc1_].x = 0;
            this.skinGroups[_loc1_].y = this.posY;
            this.posY += this.skinGroups[_loc1_].height;
            _loc1_++;
         }
         this.reskinButton.y = this.posY + 10;
         this.background.height = this.posY + 50;
      }
      
      public function createPetPicker(param1:PetPicker, param2:Vector.<PetVO>) : void
      {
         param1.setSize(new Size(this.background.width - 10,240));
         param1.setPadding(5);
         param1.setPetSize(52);
         param1.doDisableUsed = false;
         this.petPickerContainer.addChild(param1);
         this.petPickerContainer.x = 4;
         this.petPickerContainer.y = 35;
      }
      
      private function onFameOrGoldClicked() : void
      {
         closeDialogSignal.dispatch();
      }
      
      private function addChildren() : void
      {
         addChild(this.background);
         addChild(this.titleTextfield);
         addChild(this.closeButton);
         this.reskinContainer.addChild(this.reskinButton);
      }
      
      private function positionAssets() : void
      {
         positionThis();
      }
      
      private function positionReskinButton() : void
      {
         this.reskinButton.x = (this.background.width - this.reskinButton.width) / 2;
         this.reskinButton.y = this.background.height - (this.reskinButton.height + 10);
      }
      
      private function waitForTextChanged() : void
      {
         var _loc1_:SignalWaiter = new SignalWaiter();
         _loc1_.push(this.titleTextfield.textChanged);
         _loc1_.complete.addOnce(this.positionTextField);
      }
      
      private function positionTextField() : void
      {
         this.titleTextfield.y = 5;
         this.titleTextfield.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - this.titleTextfield.width) * 0.5;
      }
      
      private function onClose() : void
      {
         this.closed.dispatch();
      }
      
      public function getCloseSignal() : Signal
      {
         return closeDialogSignal;
      }
      
      public function setState(param1:String) : void
      {
         if(param1 == ReskinViewState.PETPICKER)
         {
            addChild(this.petPickerContainer);
            if(contains(this.reskinContainer))
            {
               removeChild(this.reskinContainer);
            }
         }
         else if(param1 == ReskinViewState.SKINPICKER)
         {
            addChild(this.reskinContainer);
            if(contains(this.petPickerContainer))
            {
               removeChild(this.petPickerContainer);
            }
         }
      }
   }
}

