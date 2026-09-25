package kabam.lib.console.model
{
   internal final class ActionHistory
   {
      
      private var stack:Vector.<String>;
      
      private var index:int;
      
      public function ActionHistory()
      {
         super();
         this.stack = new Vector.<String>();
         this.index = 0;
      }
      
      public function add(param1:String) : void
      {
         this.index = this.stack.push(param1);
      }
      
      public function get length() : int
      {
         return this.stack.length;
      }
      
      public function getPrevious() : String
      {
         return this.index > 0 ? this.stack[--this.index] : "";
      }
      
      public function getNext() : String
      {
         return this.index < this.stack.length - 1 ? this.stack[++this.index] : "";
      }
   }
}

