package kabam.lib.json
{
   import com.hurlant.util.Base64;
   
   public class Base64Decoder
   {
      
      public function Base64Decoder()
      {
         super();
      }
      
      public function decode(param1:String) : String
      {
         var _loc2_:RegExp = /-/g;
         var _loc3_:RegExp = /_/g;
         var _loc4_:* = int(4 - param1.length % 4);
         while(_loc4_--)
         {
            param1 += "=";
         }
         param1 = param1.replace(_loc2_,"+").replace(_loc3_,"/");
         return Base64.decode(param1);
      }
   }
}

