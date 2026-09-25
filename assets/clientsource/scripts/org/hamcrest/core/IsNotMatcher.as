package org.hamcrest.core
{
   import org.hamcrest.BaseMatcher;
   import org.hamcrest.Description;
   import org.hamcrest.Matcher;
   
   public class IsNotMatcher extends BaseMatcher
   {
      
      private var _matcher:Matcher;
      
      public function IsNotMatcher(param1:Matcher)
      {
         super();
         _matcher = param1;
      }
      
      override public function matches(param1:Object) : Boolean
      {
         return !_matcher.matches(param1);
      }
      
      override public function describeTo(param1:Description) : void
      {
         param1.appendText("not ").appendDescriptionOf(_matcher);
      }
   }
}

