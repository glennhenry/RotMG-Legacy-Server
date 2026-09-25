package org.hamcrest
{
   import flash.errors.IllegalOperationError;
   
   public class BaseDescription implements Description
   {
      
      private static const charToActionScriptSyntaxMap:Object = {
         "\"":"\\\"",
         "\n":"\\n",
         "\r":"\\r",
         "\t":"\\t"
      };
      
      public function BaseDescription()
      {
         super();
      }
      
      public function appendDescriptionOf(param1:SelfDescribing) : Description
      {
         param1.describeTo(this);
         return this;
      }
      
      private function toActionScriptSyntax(param1:Object) : void
      {
         String(param1).split("").forEach(charToActionScriptSyntax);
      }
      
      private function toSelfDescribingValue(param1:Object, param2:int = 0, param3:Array = null) : SelfDescribingValue
      {
         return new SelfDescribingValue(param1);
      }
      
      public function appendMismatchOf(param1:Matcher, param2:*) : Description
      {
         param1.describeMismatch(param2,this);
         return this;
      }
      
      public function appendText(param1:String) : Description
      {
         append(param1);
         return this;
      }
      
      public function appendValueList(param1:String, param2:String, param3:String, param4:Array) : Description
      {
         return appendList(param1,param2,param3,param4.map(toSelfDescribingValue));
      }
      
      public function appendValue(param1:Object) : Description
      {
         if(param1 == null)
         {
            append("null");
         }
         else if(param1 is String)
         {
            append("\"");
            toActionScriptSyntax(param1);
            append("\"");
         }
         else if(param1 is Number)
         {
            append("<");
            append(param1);
            append(">");
         }
         else if(param1 is int)
         {
            append("<");
            append(param1);
            append(">");
         }
         else if(param1 is uint)
         {
            append("<");
            append(param1);
            append(">");
         }
         else if(param1 is Array)
         {
            appendValueList("[",",","]",param1 as Array);
         }
         else if(param1 is XML)
         {
            append(XML(param1).toXMLString());
         }
         else
         {
            append("<");
            append(param1);
            append(">");
         }
         return this;
      }
      
      public function appendList(param1:String, param2:String, param3:String, param4:Array) : Description
      {
         var _loc6_:Object = null;
         var _loc5_:Boolean = false;
         append(param1);
         for each(_loc6_ in param4)
         {
            if(_loc5_)
            {
               append(param2);
            }
            if(_loc6_ is SelfDescribing)
            {
               appendDescriptionOf(_loc6_ as SelfDescribing);
            }
            else
            {
               appendValue(_loc6_);
            }
            _loc5_ = true;
         }
         append(param3);
         return this;
      }
      
      protected function append(param1:Object) : void
      {
         throw new IllegalOperationError("BaseDescription#append is abstract and must be overriden by a subclass");
      }
      
      public function toString() : String
      {
         throw new IllegalOperationError("BaseDescription#toString is abstract and must be overriden by a subclass");
      }
      
      private function charToActionScriptSyntax(param1:String, param2:int = 0, param3:Array = null) : void
      {
         append(charToActionScriptSyntaxMap[param1] || param1);
      }
   }
}

class SelfDescribingValue implements SelfDescribing
{
   
   private var _value:Object;
   
   public function SelfDescribingValue(param1:Object)
   {
      super();
      _value = param1;
   }
   
   public function describeTo(param1:Description) : void
   {
      param1.appendValue(_value);
   }
}
