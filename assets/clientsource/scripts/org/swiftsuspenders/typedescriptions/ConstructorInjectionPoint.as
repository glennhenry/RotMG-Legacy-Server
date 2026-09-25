package org.swiftsuspenders.typedescriptions
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import org.swiftsuspenders.Injector;
   
   public class ConstructorInjectionPoint extends MethodInjectionPoint
   {
      
      public function ConstructorInjectionPoint(param1:Array, param2:uint, param3:Dictionary)
      {
         super("ctor",param1,param2,false,param3);
      }
      
      public function createInstance(param1:Class, param2:Injector) : Object
      {
         var _loc4_:Object = null;
         var _loc3_:Array = gatherParameterValues(param1,param1,param2);
         switch(_loc3_.length)
         {
            case 1:
               _loc4_ = new param1(_loc3_[0]);
               break;
            case 2:
               _loc4_ = new param1(_loc3_[0],_loc3_[1]);
               break;
            case 3:
               _loc4_ = new param1(_loc3_[0],_loc3_[1],_loc3_[2]);
               break;
            case 4:
               _loc4_ = new param1(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3]);
               break;
            case 5:
               _loc4_ = new param1(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3],_loc3_[4]);
               break;
            case 6:
               _loc4_ = new param1(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5]);
               break;
            case 7:
               _loc4_ = new param1(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5],_loc3_[6]);
               break;
            case 8:
               _loc4_ = new param1(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5],_loc3_[6],_loc3_[7]);
               break;
            case 9:
               _loc4_ = new param1(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5],_loc3_[6],_loc3_[7],_loc3_[8]);
               break;
            case 10:
               _loc4_ = new param1(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3],_loc3_[4],_loc3_[5],_loc3_[6],_loc3_[7],_loc3_[8],_loc3_[9]);
         }
         _loc3_.length = 0;
         return _loc4_;
      }
   }
}

