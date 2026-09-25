package kabam.rotmg.pets.controller
{
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.pets.view.dialogs.CaretakerQueryDialog;
   
   public class OpenCaretakerQueryDialogCommand
   {
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function OpenCaretakerQueryDialogCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:CaretakerQueryDialog = new CaretakerQueryDialog();
         this.openDialog.dispatch(_loc1_);
      }
   }
}

