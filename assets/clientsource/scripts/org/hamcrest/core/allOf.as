package org.hamcrest.core
{
   import org.hamcrest.Matcher;
   
   public function allOf(... rest) : Matcher
   {
      var _loc2_:Array = rest;
      if(rest.length == 1 && rest[0] is Array)
      {
         _loc2_ = rest[0];
      }
      return new AllOfMatcher(_loc2_);
   }
}

