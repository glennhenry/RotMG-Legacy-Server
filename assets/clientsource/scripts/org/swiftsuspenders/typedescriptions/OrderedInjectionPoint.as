package org.swiftsuspenders.typedescriptions
{
   public class OrderedInjectionPoint extends MethodInjectionPoint
   {
      
      public var order:int;
      
      public function OrderedInjectionPoint(param1:String, param2:Array, param3:uint, param4:int)
      {
         super(param1,param2,param3,false,null);
         this.order = param4;
      }
   }
}

