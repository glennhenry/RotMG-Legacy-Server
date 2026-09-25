package robotlegs.bender.framework.impl
{
   import org.swiftsuspenders.Injector;
   
   public function guardsApprove(param1:Array, param2:Injector = null) : Boolean
   {
      var _loc3_:Object = null;
      for each(_loc3_ in param1)
      {
         if(_loc3_ is Function)
         {
            if(!(_loc3_ as Function)())
            {
               return false;
            }
         }
         else
         {
            if(_loc3_ is Class)
            {
               _loc3_ = param2 ? param2.getInstance(_loc3_ as Class) : new (_loc3_ as Class)();
            }
            if(_loc3_.approve() == false)
            {
               return false;
            }
         }
      }
      return true;
   }
}

