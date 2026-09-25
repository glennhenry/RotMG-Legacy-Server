package org.hamcrest
{
   import flash.errors.IllegalOperationError;
   
   public class DiagnosingMatcher extends BaseMatcher
   {
      
      public function DiagnosingMatcher()
      {
         super();
      }
      
      override public function describeMismatch(param1:Object, param2:Description) : void
      {
         matchesOrDescribesMismatch(param1,param2);
      }
      
      protected function matchesOrDescribesMismatch(param1:Object, param2:Description) : Boolean
      {
         throw new IllegalOperationError("DiagnosingMatcher#matches is abstract and must be overriden in a subclass");
      }
      
      override public function matches(param1:Object) : Boolean
      {
         return matchesOrDescribesMismatch(param1,new NullDescription());
      }
   }
}

