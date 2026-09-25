package kabam.lib.ui.impl
{
   import flash.display.DisplayObject;
   import kabam.lib.ui.api.Layout;
   
   public class NullLayout implements Layout
   {
      
      public function NullLayout()
      {
         super();
      }
      
      public function getPadding() : int
      {
         return 0;
      }
      
      public function setPadding(param1:int) : void
      {
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:int = 0) : void
      {
      }
   }
}

