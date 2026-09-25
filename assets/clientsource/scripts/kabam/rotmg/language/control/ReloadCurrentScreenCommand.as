package kabam.rotmg.language.control
{
   import kabam.rotmg.core.model.ScreenModel;
   import kabam.rotmg.core.signals.InvalidateDataSignal;
   import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.ui.view.TitleView;
   
   public class ReloadCurrentScreenCommand
   {
      
      [Inject]
      public var invalidate:InvalidateDataSignal;
      
      [Inject]
      public var setScreen:SetScreenWithValidDataSignal;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var screensModel:ScreenModel;
      
      public function ReloadCurrentScreenCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:Class = this.screensModel.getCurrentScreenType() || TitleView;
         this.invalidate.dispatch();
         this.closeDialogs.dispatch();
         this.setScreen.dispatch(new _loc1_());
      }
   }
}

