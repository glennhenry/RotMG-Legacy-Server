package kabam.rotmg.util.graphics
{
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.geom.Rectangle;
   
   public class ButtonLayoutHelper
   {
      
      public function ButtonLayoutHelper()
      {
         super();
      }
      
      public function layout(param1:int, ... rest) : void
      {
         var _loc3_:int = int(rest.length);
         switch(_loc3_)
         {
            case 1:
               this.centerButton(param1,rest[0]);
               break;
            case 2:
               this.twoButtons(param1,rest[0],rest[1]);
               break;
            default:
               throw new IllegalOperationError("Currently unable to layout more than 2 buttons");
         }
      }
      
      private function centerButton(param1:int, param2:DisplayObject) : void
      {
         var _loc3_:Rectangle = param2.getRect(param2);
         param2.x = (param1 - _loc3_.width) * 0.5 - _loc3_.left;
      }
      
      private function twoButtons(param1:int, param2:DisplayObject, param3:DisplayObject) : void
      {
         var _loc5_:Rectangle = null;
         var _loc4_:Rectangle = param2.getRect(param2);
         _loc5_ = param3.getRect(param3);
         param2.x = (param1 - 2 * param2.width) * 0.25 - _loc4_.left;
         param3.x = (3 * param1 - 2 * param3.width) * 0.25 - _loc5_.left;
      }
   }
}

