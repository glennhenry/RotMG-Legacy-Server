package kabam.rotmg.pets.view.components
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class FusionStrengthFactory
   {
      
      private static const FONT_SIZE:int = 14;
      
      public function FusionStrengthFactory()
      {
         super();
      }
      
      public static function makeRoundedBox() : DisplayObjectContainer
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(5460819);
         _loc1_.graphics.drawRoundRect(0,0,222,40,10,10);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      public static function makeText() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc1_.setStringBuilder(new LineBuilder().setParams("FusionStrength.text")).setAutoSize(TextFieldAutoSize.LEFT).setColor(FusionStrength.DEFAULT_COLOR);
         configureText(_loc1_);
         return _loc1_;
      }
      
      public static function makeFusionText() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setAutoSize(TextFieldAutoSize.RIGHT);
         configureText(_loc1_);
         return _loc1_;
      }
      
      private static function configureText(param1:TextFieldDisplayConcrete) : void
      {
         param1.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE).setSize(FONT_SIZE).setBold(true);
      }
   }
}

