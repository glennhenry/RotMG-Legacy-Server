package robotlegs.bender.framework.impl
{
   import flash.utils.getQualifiedClassName;
   
   public class UID
   {
      
      private static var _i:uint;
      
      public function UID()
      {
         super();
      }
      
      public static function create(param1:* = null) : String
      {
         if(param1 is Class)
         {
            param1 = getQualifiedClassName(param1).split("::").pop();
         }
         return (param1 ? param1 + "-" : "") + (_i++).toString(16) + "-" + (Math.random() * 255).toString(16);
      }
   }
}

