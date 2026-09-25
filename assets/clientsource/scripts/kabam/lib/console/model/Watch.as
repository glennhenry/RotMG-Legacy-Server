package kabam.lib.console.model
{
   public class Watch
   {
      
      public var name:String;
      
      public var data:String;
      
      public function Watch(param1:String, param2:String = "")
      {
         super();
         this.name = param1;
         this.data = param2;
      }
      
      public function toString() : String
      {
         return this.data;
      }
   }
}

