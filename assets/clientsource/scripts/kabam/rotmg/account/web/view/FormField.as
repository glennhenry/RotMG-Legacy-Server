package kabam.rotmg.account.web.view
{
   import com.company.ui.BaseSimpleText;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   
   public class FormField extends Sprite
   {
      
      protected static const BACKGROUND_COLOR:uint = 3355443;
      
      protected static const ERROR_BORDER_COLOR:uint = 16549442;
      
      protected static const NORMAL_BORDER_COLOR:uint = 4539717;
      
      protected static const TEXT_COLOR:uint = 11776947;
      
      public function FormField()
      {
         super();
      }
      
      public function getHeight() : Number
      {
         return 0;
      }
      
      protected function drawSimpleTextBackground(param1:BaseSimpleText, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc5_:uint = param4 ? ERROR_BORDER_COLOR : NORMAL_BORDER_COLOR;
         graphics.lineStyle(2,_loc5_,1,false,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         graphics.beginFill(BACKGROUND_COLOR,1);
         graphics.drawRect(param1.x - param2 - 5,param1.y - param3,param1.width + param2 * 2,param1.height + param3 * 2);
         graphics.endFill();
         graphics.lineStyle();
      }
   }
}

