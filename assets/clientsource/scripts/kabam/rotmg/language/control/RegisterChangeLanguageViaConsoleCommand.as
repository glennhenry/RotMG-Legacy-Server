package kabam.rotmg.language.control
{
   import kabam.lib.console.signals.RegisterConsoleActionSignal;
   import kabam.lib.console.vo.ConsoleAction;
   
   public class RegisterChangeLanguageViaConsoleCommand
   {
      
      [Inject]
      public var registerConsoleAction:RegisterConsoleActionSignal;
      
      [Inject]
      public var setLanguage:SetLanguageSignal;
      
      public function RegisterChangeLanguageViaConsoleCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:ConsoleAction = null;
         _loc1_ = new ConsoleAction();
         _loc1_.name = "setlang";
         _loc1_.description = "Sets the locale language (defaults to en-US)";
         this.registerConsoleAction.dispatch(_loc1_,this.setLanguage);
      }
   }
}

