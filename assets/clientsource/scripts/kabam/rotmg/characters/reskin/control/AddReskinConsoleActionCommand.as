package kabam.rotmg.characters.reskin.control
{
   import kabam.lib.console.signals.RegisterConsoleActionSignal;
   import kabam.lib.console.vo.ConsoleAction;
   
   public class AddReskinConsoleActionCommand
   {
      
      [Inject]
      public var register:RegisterConsoleActionSignal;
      
      [Inject]
      public var openReskinDialogSignal:OpenReskinDialogSignal;
      
      public function AddReskinConsoleActionCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:ConsoleAction = null;
         _loc1_ = new ConsoleAction();
         _loc1_.name = "reskin";
         _loc1_.description = "opens the reskin UI";
         this.register.dispatch(_loc1_,this.openReskinDialogSignal);
      }
   }
}

