package kabam.lib.console.model
{
   import kabam.lib.console.vo.ConsoleAction;
   import org.osflash.signals.Signal;
   
   public final class Console
   {
      
      private var hash:ActionHash;
      
      private var history:ActionHistory;
      
      public function Console()
      {
         super();
         this.hash = new ActionHash();
         this.history = new ActionHistory();
      }
      
      public function register(param1:ConsoleAction, param2:Signal) : void
      {
         this.hash.register(param1.name,param1.description,param2);
      }
      
      public function hasAction(param1:String) : Boolean
      {
         return this.hash.has(param1);
      }
      
      public function execute(param1:String) : void
      {
         this.history.add(param1);
         this.hash.execute(param1);
      }
      
      public function getNames() : Vector.<String>
      {
         return this.hash.getNames();
      }
      
      public function getPreviousAction() : String
      {
         return this.history.getPrevious();
      }
      
      public function getNextAction() : String
      {
         return this.history.getNext();
      }
   }
}

