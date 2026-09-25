package org.hamcrest.core
{
   import org.hamcrest.Description;
   import org.hamcrest.DiagnosingMatcher;
   import org.hamcrest.Matcher;
   
   public class AllOfMatcher extends DiagnosingMatcher
   {
      
      private var _matchers:Array;
      
      public function AllOfMatcher(param1:Array)
      {
         super();
         _matchers = param1 || [];
      }
      
      override protected function matchesOrDescribesMismatch(param1:Object, param2:Description) : Boolean
      {
         var _loc3_:Matcher = null;
         for each(_loc3_ in _matchers)
         {
            if(!_loc3_.matches(param1))
            {
               param2.appendDescriptionOf(_loc3_).appendText(" ").appendMismatchOf(_loc3_,param1);
               return false;
            }
         }
         return true;
      }
      
      override public function describeTo(param1:Description) : void
      {
         param1.appendList("("," and ",")",_matchers);
      }
   }
}

