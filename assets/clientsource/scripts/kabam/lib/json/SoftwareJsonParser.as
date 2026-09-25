package kabam.lib.json
{
   import com.adobe.serialization.json.JSON;
   
   public class SoftwareJsonParser implements JsonParser
   {
      
      public function SoftwareJsonParser()
      {
         super();
      }
      
      public function stringify(param1:Object) : String
      {
         return com.adobe.serialization.json.JSON.encode(param1);
      }
      
      public function parse(param1:String) : Object
      {
         return com.adobe.serialization.json.JSON.decode(param1);
      }
   }
}

