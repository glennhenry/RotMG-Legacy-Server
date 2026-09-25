package kabam.rotmg.pets.view.components
{
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import kabam.rotmg.util.graphics.BevelRect;
   import kabam.rotmg.util.graphics.GraphicsHelper;
   
   public class PopupWindowBackground extends Sprite
   {
      
      public static const HORIZONTAL_DIVISION:String = "HORIZONTAL_DIVISION";
      
      public static const VERTICAL_DIVISION:String = "VERTICAL_DIVISION";
      
      private static const BEVEL:int = 4;
      
      public static const TYPE_DEFAULT_GREY:int = 0;
      
      public static const TYPE_TRANSPARENT_WITH_HEADER:int = 1;
      
      public static const TYPE_TRANSPARENT_WITHOUT_HEADER:int = 2;
      
      public static const TYPE_DEFAULT_BLACK:int = 3;
      
      public function PopupWindowBackground()
      {
         super();
      }
      
      public function draw(param1:int, param2:int, param3:int = 0) : void
      {
         var _loc4_:BevelRect = new BevelRect(param1,param2,BEVEL);
         var _loc5_:GraphicsHelper = new GraphicsHelper();
         graphics.lineStyle(1,16777215,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3);
         if(param3 == TYPE_TRANSPARENT_WITH_HEADER)
         {
            graphics.lineStyle(1,3552822,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3);
            graphics.beginFill(3552822,1);
            _loc5_.drawBevelRect(1,1,new BevelRect(param1 - 2,29,BEVEL),graphics);
            graphics.endFill();
            graphics.beginFill(3552822,1);
            graphics.drawRect(1,15,param1 - 2,15);
            graphics.endFill();
            graphics.lineStyle(2,16777215,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3);
            graphics.beginFill(3552822,0);
            _loc5_.drawBevelRect(0,0,_loc4_,graphics);
            graphics.endFill();
         }
         else if(param3 == TYPE_TRANSPARENT_WITHOUT_HEADER)
         {
            graphics.lineStyle(2,16777215,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3);
            graphics.beginFill(3552822,0);
            _loc5_.drawBevelRect(0,0,_loc4_,graphics);
            graphics.endFill();
         }
         else if(param3 == TYPE_DEFAULT_GREY)
         {
            graphics.beginFill(3552822);
            _loc5_.drawBevelRect(0,0,_loc4_,graphics);
            graphics.endFill();
         }
         else if(param3 == TYPE_DEFAULT_BLACK)
         {
            graphics.beginFill(0);
            _loc5_.drawBevelRect(0,0,_loc4_,graphics);
            graphics.endFill();
         }
      }
      
      public function divide(param1:String, param2:int) : void
      {
         if(param1 == HORIZONTAL_DIVISION)
         {
            this.divideHorizontally(param2);
         }
         else if(param1 == VERTICAL_DIVISION)
         {
            this.divideVertically(param2);
         }
      }
      
      private function divideHorizontally(param1:int) : void
      {
         graphics.lineStyle();
         graphics.endFill();
         graphics.moveTo(1,param1);
         graphics.beginFill(6710886,1);
         graphics.drawRect(1,param1,width - 2,2);
      }
      
      private function divideVertically(param1:int) : void
      {
         graphics.lineStyle();
         graphics.moveTo(param1,1);
         graphics.lineStyle(2,6710886);
         graphics.lineTo(param1,height - 1);
      }
   }
}

