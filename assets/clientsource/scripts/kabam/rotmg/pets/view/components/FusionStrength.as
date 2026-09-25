package kabam.rotmg.pets.view.components
{
   import flash.display.Sprite;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class FusionStrength extends Sprite
   {
      
      public static const MAXED_COLOR:uint = 8768801;
      
      public static const BAD_COLOR:uint = 16711680;
      
      public static const DEFAULT_COLOR:int = 11776947;
      
      public static const LOW:String = "FusionStrength.Low";
      
      public static const BAD:String = "FusionStrength.Bad";
      
      public static const GOOD:String = "FusionStrength.Good";
      
      public static const GREAT:String = "FusionStrength.Great";
      
      public static const FANTASTIC:String = "FusionStrength.Fantastic";
      
      public static const MAXED:String = "FusionStrength.Maxed";
      
      public static const NONE:String = "FusionStrength.None";
      
      private static const PADDING:Number = 16;
      
      public var fusionText:TextFieldDisplayConcrete;
      
      public function FusionStrength()
      {
         super();
         addChild(FusionStrengthFactory.makeRoundedBox());
         this.addText();
         this.addFusionText();
      }
      
      private static function getKeyFor(param1:Number) : String
      {
         if(isMaxed(param1))
         {
            return MAXED;
         }
         if(param1 > 0.8)
         {
            return FANTASTIC;
         }
         if(param1 > 0.6)
         {
            return GREAT;
         }
         if(param1 > 0.4)
         {
            return GOOD;
         }
         if(param1 > 0.2)
         {
            return LOW;
         }
         return BAD;
      }
      
      private static function isMaxed(param1:Number) : Boolean
      {
         return Math.abs(param1 - 1) < 0.001;
      }
      
      private static function isBad(param1:Number) : Boolean
      {
         return param1 < 0.2;
      }
      
      public function reset() : void
      {
         this.fusionText.setStringBuilder(new LineBuilder().setParams(NONE));
         this.fusionText.setColor(DEFAULT_COLOR);
      }
      
      private function addText() : void
      {
         var _loc1_:TextFieldDisplayConcrete = FusionStrengthFactory.makeText();
         _loc1_.x = PADDING;
         _loc1_.y = this.getMiddle();
         addChild(_loc1_);
      }
      
      private function addFusionText() : void
      {
         this.fusionText = FusionStrengthFactory.makeFusionText();
         this.fusionText.x = width - PADDING;
         this.fusionText.y = this.getMiddle();
         this.fusionText.setStringBuilder(new LineBuilder().setParams(NONE));
         this.fusionText.setColor(DEFAULT_COLOR);
         addChild(this.fusionText);
      }
      
      private function getMiddle() : Number
      {
         return height / 2;
      }
      
      public function setFusionStrength(param1:Number) : void
      {
         var _loc2_:String = getKeyFor(param1);
         this.fusionText.setStringBuilder(new LineBuilder().setParams(_loc2_));
         this.colorText(param1);
      }
      
      private function colorText(param1:Number) : void
      {
         if(isMaxed(param1))
         {
            this.fusionText.setColor(MAXED_COLOR);
         }
         else if(isBad(param1))
         {
            this.fusionText.setColor(BAD_COLOR);
         }
         else
         {
            this.fusionText.setColor(DEFAULT_COLOR);
         }
      }
   }
}

