package org.hamcrest.core
{
   import org.hamcrest.Matcher;
   import org.hamcrest.object.equalTo;
   
   public function not(param1:Object) : Matcher
   {
      if(param1 is Matcher)
      {
         return new IsNotMatcher(param1 as Matcher);
      }
      return not(equalTo(param1));
   }
}

