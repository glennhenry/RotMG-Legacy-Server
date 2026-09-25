package robotlegs.bender.extensions.logging.impl
{
   public class LogMessageParser
   {
      
      public function LogMessageParser()
      {
         super();
      }
      
      public function parseMessage(param1:String, param2:Array) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param2)
         {
            _loc3_ = int(param2.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               param1 = param1.split("{" + _loc4_ + "}").join(param2[_loc4_]);
               _loc4_++;
            }
         }
         return param1;
      }
   }
}

