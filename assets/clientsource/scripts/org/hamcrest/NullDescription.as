package org.hamcrest
{
   public class NullDescription implements Description
   {
      
      public function NullDescription()
      {
         super();
      }
      
      public function appendMismatchOf(param1:Matcher, param2:*) : Description
      {
         return this;
      }
      
      public function toString() : String
      {
         return "";
      }
      
      public function appendText(param1:String) : Description
      {
         return this;
      }
      
      public function appendValue(param1:Object) : Description
      {
         return this;
      }
      
      public function appendList(param1:String, param2:String, param3:String, param4:Array) : Description
      {
         return this;
      }
      
      public function appendDescriptionOf(param1:SelfDescribing) : Description
      {
         return this;
      }
   }
}

