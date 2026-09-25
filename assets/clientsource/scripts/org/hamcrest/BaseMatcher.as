package org.hamcrest
{
   import flash.errors.IllegalOperationError;
   
   public class BaseMatcher implements Matcher
   {
      
      public function BaseMatcher()
      {
         super();
      }
      
      public function describeMismatch(param1:Object, param2:Description) : void
      {
         param2.appendText("was ").appendValue(param1);
      }
      
      public function matches(param1:Object) : Boolean
      {
         throw new IllegalOperationError("BaseMatcher#matches must be override by subclass");
      }
      
      public function describeTo(param1:Description) : void
      {
         throw new IllegalOperationError("BaseMatcher#describeTo must be override by subclass");
      }
      
      public function toString() : String
      {
         return StringDescription.toString(this);
      }
   }
}

