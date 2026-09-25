package org.hamcrest.object
{
   import org.hamcrest.Matcher;
   
   public function equalTo(param1:Object) : Matcher
   {
      return new IsEqualMatcher(param1);
   }
}

