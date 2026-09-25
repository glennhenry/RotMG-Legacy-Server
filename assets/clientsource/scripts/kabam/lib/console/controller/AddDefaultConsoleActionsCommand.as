package kabam.lib.console.controller
{
   import kabam.lib.console.signals.ClearConsoleSignal;
   import kabam.lib.console.signals.CopyConsoleTextSignal;
   import kabam.lib.console.signals.ListActionsSignal;
   import kabam.lib.console.signals.RegisterConsoleActionSignal;
   import kabam.lib.console.signals.RemoveConsoleSignal;
   import kabam.lib.console.vo.ConsoleAction;
   
   public class AddDefaultConsoleActionsCommand
   {
      
      [Inject]
      public var register:RegisterConsoleActionSignal;
      
      [Inject]
      public var listActions:ListActionsSignal;
      
      [Inject]
      public var clearConsole:ClearConsoleSignal;
      
      [Inject]
      public var removeConsole:RemoveConsoleSignal;
      
      [Inject]
      public var copyConsoleText:CopyConsoleTextSignal;
      
      public function AddDefaultConsoleActionsCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:ConsoleAction = null;
         _loc1_ = new ConsoleAction();
         _loc1_.name = "list";
         _loc1_.description = "lists available console commands";
         var _loc2_:ConsoleAction = new ConsoleAction();
         _loc2_.name = "clear";
         _loc2_.description = "clears the console";
         var _loc3_:ConsoleAction = new ConsoleAction();
         _loc3_.name = "exit";
         _loc3_.description = "closes the console";
         var _loc4_:ConsoleAction = new ConsoleAction();
         _loc4_.name = "copy";
         _loc4_.description = "copies the contents of the console to the clipboard";
         this.register.dispatch(_loc1_,this.listActions);
         this.register.dispatch(_loc2_,this.clearConsole);
         this.register.dispatch(_loc3_,this.removeConsole);
         this.register.dispatch(_loc4_,this.copyConsoleText);
      }
   }
}

