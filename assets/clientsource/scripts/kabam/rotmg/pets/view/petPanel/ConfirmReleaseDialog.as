package kabam.rotmg.pets.view.petPanel
{
   import com.company.assembleegameclient.ui.dialogs.CloseDialogComponent;
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import com.company.assembleegameclient.ui.dialogs.DialogCloser;
   import flash.events.Event;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.view.dialogs.PetDialog;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class ConfirmReleaseDialog extends PetDialog implements DialogCloser
   {
      
      [Inject]
      public var release:ReleasePetSignal;
      
      private const closeDialogComponent:CloseDialogComponent = new CloseDialogComponent();
      
      private var petVO:PetVO;
      
      public function ConfirmReleaseDialog(param1:PetVO)
      {
         super(TextKey.PET_PANEL_CONFIRM_TITLE,TextKey.PET_PANEL_CONFIRM__SUBTEXT,TextKey.RELEASE,TextKey.FRAME_CANCEL,null);
         this.petVO = param1;
         this.addButtonBehavior();
      }
      
      override protected function setDialogWidth() : int
      {
         return 400;
      }
      
      private function addButtonBehavior() : void
      {
         this.closeDialogComponent.add(this,Dialog.RIGHT_BUTTON);
         this.closeDialogComponent.add(this,Dialog.LEFT_BUTTON);
         addEventListener(Dialog.LEFT_BUTTON,this.onLeftButton);
      }
      
      private function onLeftButton(param1:Event) : void
      {
         removeEventListener(Dialog.LEFT_BUTTON,this.onLeftButton);
         this.release.dispatch(this.petVO.getID());
      }
      
      public function getCloseSignal() : Signal
      {
         return this.closeDialogComponent.getCloseSignal();
      }
      
      public function getPetVO() : PetVO
      {
         return this.petVO;
      }
   }
}

