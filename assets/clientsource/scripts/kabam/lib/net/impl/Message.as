package kabam.lib.net.impl
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class Message
   {
      
      public var pool:MessagePool;
      
      public var prev:Message;
      
      public var next:Message;
      
      private var isCallback:Boolean;
      
      public var id:uint;
      
      public var callback:Function;
      
      public function Message(param1:uint, param2:Function = null)
      {
         super();
         this.id = param1;
         this.isCallback = param2 != null;
         this.callback = param2;
      }
      
      public function parseFromInput(param1:IDataInput) : void
      {
      }
      
      public function writeToOutput(param1:IDataOutput) : void
      {
      }
      
      public function toString() : String
      {
         return this.formatToString("MESSAGE","id");
      }
      
      protected function formatToString(param1:String, ... rest) : String
      {
         var _loc3_:String = "[" + param1;
         var _loc4_:int = 0;
         while(_loc4_ < rest.length)
         {
            _loc3_ += " " + rest[_loc4_] + "=\"" + this[rest[_loc4_]] + "\"";
            _loc4_++;
         }
         return _loc3_ + "]";
      }
      
      public function consume() : void
      {
         this.isCallback && this.callback(this);
         this.prev = null;
         this.next = null;
         this.pool.append(this);
      }
   }
}

