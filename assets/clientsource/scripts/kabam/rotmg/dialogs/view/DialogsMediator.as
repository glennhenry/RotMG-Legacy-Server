package kabam.rotmg.dialogs.view
{
   import flash.display.Sprite;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.dialogs.control.PopDialogSignal;
   import kabam.rotmg.dialogs.control.PushDialogSignal;
   import kabam.rotmg.dialogs.control.ShowDialogBackgroundSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class DialogsMediator extends Mediator
   {
      
      [Inject]
      public var view:DialogsView;
      
      [Inject]
      public var openDialogNoModal:OpenDialogNoModalSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var showDialogBackground:ShowDialogBackgroundSignal;
      
      [Inject]
      public var pushDialogSignal:PushDialogSignal;
      
      [Inject]
      public var popDialogSignal:PopDialogSignal;
      
      public function DialogsMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.showDialogBackground.add(this.onShowDialogBackground);
         this.openDialog.add(this.onOpenDialog);
         this.openDialogNoModal.add(this.onOpenDialogNoModal);
         this.closeDialog.add(this.onCloseDialog);
         this.pushDialogSignal.add(this.onPushDialog);
         this.popDialogSignal.add(this.onPopDialog);
      }
      
      private function onPushDialog(param1:Sprite) : void
      {
         this.view.push(param1);
      }
      
      private function onPopDialog() : void
      {
         this.view.pop();
      }
      
      override public function destroy() : void
      {
         this.showDialogBackground.remove(this.onShowDialogBackground);
         this.openDialog.remove(this.onOpenDialog);
         this.openDialogNoModal.remove(this.onOpenDialogNoModal);
         this.closeDialog.remove(this.onCloseDialog);
         this.pushDialogSignal.remove(this.onPushDialog);
         this.popDialogSignal.remove(this.onPopDialog);
      }
      
      private function onShowDialogBackground(param1:int = 1381653) : void
      {
         this.view.showBackground(param1);
      }
      
      private function onOpenDialog(param1:Sprite) : void
      {
         this.view.show(param1,true);
      }
      
      private function onOpenDialogNoModal(param1:Sprite) : void
      {
         this.view.show(param1,false);
      }
      
      private function onCloseDialog() : void
      {
         this.view.stage.focus = null;
         this.view.hideAll();
      }
   }
}

