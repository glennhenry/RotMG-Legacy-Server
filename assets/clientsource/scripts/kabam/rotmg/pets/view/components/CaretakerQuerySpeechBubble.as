package kabam.rotmg.pets.view.components
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flashx.textLayout.formats.VerticalAlign;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.util.graphics.BevelRect;
   import kabam.rotmg.util.graphics.GraphicsHelper;
   
   public class CaretakerQuerySpeechBubble extends Sprite
   {
      
      private const WIDTH:int = 174;
      
      private const HEIGHT:int = 42;
      
      private const BEVEL:int = 4;
      
      private const POINT:int = 6;
      
      public function CaretakerQuerySpeechBubble(param1:String)
      {
         super();
         addChild(this.makeBubble());
         addChild(this.makeText(param1));
      }
      
      private function makeBubble() : Shape
      {
         var _loc1_:Shape = new Shape();
         this.drawBubble(_loc1_);
         return _loc1_;
      }
      
      private function drawBubble(param1:Shape) : void
      {
         var _loc2_:GraphicsHelper = new GraphicsHelper();
         var _loc3_:BevelRect = new BevelRect(this.WIDTH,this.HEIGHT,this.BEVEL);
         var _loc4_:int = this.HEIGHT / 2;
         param1.graphics.beginFill(14737632);
         _loc2_.drawBevelRect(0,0,_loc3_,param1.graphics);
         param1.graphics.endFill();
         param1.graphics.beginFill(14737632);
         param1.graphics.moveTo(0,_loc4_ - this.POINT);
         param1.graphics.lineTo(-this.POINT,_loc4_);
         param1.graphics.lineTo(0,_loc4_ + this.POINT);
         param1.graphics.endFill();
      }
      
      private function makeText(param1:String) : TextFieldDisplayConcrete
      {
         var _loc2_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setAutoSize(TextFieldAutoSize.CENTER).setVerticalAlign(VerticalAlign.MIDDLE).setPosition(this.WIDTH / 2,this.HEIGHT / 2);
         _loc2_.setStringBuilder(new LineBuilder().setParams(param1));
         return _loc2_;
      }
   }
}

