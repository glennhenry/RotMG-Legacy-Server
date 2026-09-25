package org.hamcrest
{
   public class StringDescription extends BaseDescription
   {
      
      private var _out:String;
      
      public function StringDescription()
      {
         super();
         clear();
      }
      
      public static function toString(param1:SelfDescribing) : String
      {
         return new StringDescription().appendDescriptionOf(param1).toString();
      }
      
      override protected function append(param1:Object) : void
      {
         _out += String(param1);
      }
      
      override public function toString() : String
      {
         return _out;
      }
      
      public function clear() : void
      {
         _out = "";
      }
   }
}

