package org.hamcrest.object
{
   import flash.utils.getQualifiedClassName;
   import org.hamcrest.BaseMatcher;
   import org.hamcrest.Description;
   
   public class IsInstanceOfMatcher extends BaseMatcher
   {
      
      private var _typeName:String;
      
      private var _type:Class;
      
      public function IsInstanceOfMatcher(param1:Class)
      {
         super();
         _type = param1;
         _typeName = getQualifiedClassName(param1);
      }
      
      override public function describeTo(param1:Description) : void
      {
         param1.appendText("an instance of ").appendText(_typeName);
      }
      
      override public function matches(param1:Object) : Boolean
      {
         return param1 is _type;
      }
   }
}

