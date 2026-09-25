package kabam.rotmg.account.steam.view
{
   import kabam.rotmg.account.core.signals.RegisterAccountSignal;
   import kabam.rotmg.account.core.view.RegisterWebAccountDialog;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class SteamRegisterWebAccountMediator extends Mediator
   {
      
      [Inject]
      public var view:RegisterWebAccountDialog;
      
      [Inject]
      public var register:RegisterAccountSignal;
      
      [Inject]
      public var closeDialogsSignal:CloseDialogsSignal;
      
      public function SteamRegisterWebAccountMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.register.add(this.onRegister);
         this.view.cancel.add(this.onClose);
      }
      
      override public function destroy() : void
      {
         this.view.register.remove(this.onRegister);
      }
      
      private function onRegister(param1:AccountData) : void
      {
         this.register.dispatch(param1);
      }
      
      private function onClose() : void
      {
         this.closeDialogsSignal.dispatch();
      }
   }
}

