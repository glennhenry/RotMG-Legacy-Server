package kabam.rotmg.game.focus.control
{
   import kabam.lib.console.signals.RegisterConsoleActionSignal;
   import kabam.lib.console.vo.ConsoleAction;
   
   public class AddGameFocusConsoleActionCommand
   {
      
      [Inject]
      public var register:RegisterConsoleActionSignal;
      
      [Inject]
      public var setFocus:SetGameFocusSignal;
      
      public function AddGameFocusConsoleActionCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:ConsoleAction = null;
         _loc1_ = new ConsoleAction();
         _loc1_.name = "follow";
         _loc1_.description = "follow a game object (by name)";
         this.register.dispatch(_loc1_,this.setFocus);
      }
   }
}

