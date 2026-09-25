package kabam.rotmg.util.components
{
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import kabam.rotmg.util.graphics.BevelRect;
   import kabam.rotmg.util.graphics.GraphicsHelper;
   
   public class DialogBackground extends Sprite
   {
      
      private static const BEVEL:int = 4;
      
      public function DialogBackground()
      {
         super();
      }
      
      public function draw(param1:int, param2:int) : void
      {
         var _loc3_:BevelRect = new BevelRect(param1,param2,BEVEL);
         var _loc4_:GraphicsHelper = new GraphicsHelper();
         graphics.lineStyle(1,16777215,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3);
         graphics.beginFill(3552822);
         _loc4_.drawBevelRect(0,0,_loc3_,graphics);
         graphics.endFill();
      }
   }
}

