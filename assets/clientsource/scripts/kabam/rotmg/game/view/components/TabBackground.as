package kabam.rotmg.game.view.components
{
   import flash.display.Sprite;
   
   public class TabBackground extends Sprite
   {
      
      public function TabBackground(param1:Number = 28, param2:Number = 35)
      {
         super();
         graphics.beginFill(TabConstants.TAB_COLOR);
         graphics.drawRoundRect(0,0,param1,param2,TabConstants.TAB_CORNER_RADIUS,TabConstants.TAB_CORNER_RADIUS);
         graphics.endFill();
      }
   }
}

