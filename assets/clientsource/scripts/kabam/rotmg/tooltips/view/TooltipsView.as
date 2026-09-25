package kabam.rotmg.tooltips.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class TooltipsView extends Sprite
   {
      
      private var toolTip:DisplayObject;
      
      public function TooltipsView()
      {
         super();
      }
      
      public function show(param1:DisplayObject) : void
      {
         this.hide();
         this.toolTip = param1;
         if(param1)
         {
            addChild(param1);
         }
      }
      
      public function hide() : void
      {
         if(Boolean(this.toolTip) && Boolean(this.toolTip.parent))
         {
            this.toolTip.parent.removeChild(this.toolTip);
         }
         this.toolTip = null;
      }
   }
}

