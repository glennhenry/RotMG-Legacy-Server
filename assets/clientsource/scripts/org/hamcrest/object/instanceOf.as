package org.hamcrest.object
{
   import org.hamcrest.Matcher;
   
   public function instanceOf(param1:Class) : Matcher
   {
      return new IsInstanceOfMatcher(param1);
   }
}

