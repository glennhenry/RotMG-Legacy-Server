package kabam.lib.ui.impl
{
   import flash.display.DisplayObject;
   import kabam.lib.ui.api.Layout;
   
   public class VerticalLayout implements Layout
   {
      
      private var padding:int = 0;
      
      public function VerticalLayout()
      {
         super();
      }
      
      public function getPadding() : int
      {
         return this.padding;
      }
      
      public function setPadding(param1:int) : void
      {
         this.padding = param1;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:int = 0) : void
      {
         var _loc6_:DisplayObject = null;
         var _loc3_:int = param2;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            _loc6_.y = _loc3_;
            _loc3_ += _loc6_.height + this.padding;
            _loc5_++;
         }
      }
   }
}

