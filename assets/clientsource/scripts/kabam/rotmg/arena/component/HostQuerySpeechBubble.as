package kabam.rotmg.arena.component
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flashx.textLayout.formats.VerticalAlign;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.util.graphics.BevelRect;
   import kabam.rotmg.util.graphics.GraphicsHelper;
   
   public class HostQuerySpeechBubble extends Sprite
   {
      
      private const WIDTH:int = 174;
      
      private const HEIGHT:int = 225;
      
      private const BEVEL:int = 4;
      
      private const POINT:int = 6;
      
      private const PADDING:int = 8;
      
      public function HostQuerySpeechBubble(param1:String)
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
         param1.graphics.beginFill(14737632);
         _loc2_.drawBevelRect(0,0,_loc3_,param1.graphics);
         param1.graphics.endFill();
         param1.graphics.beginFill(14737632);
         param1.graphics.moveTo(0,21 - this.POINT);
         param1.graphics.lineTo(-this.POINT,21);
         param1.graphics.lineTo(0,21 + this.POINT);
         param1.graphics.endFill();
      }
      
      private function makeText(param1:String) : TextFieldDisplayConcrete
      {
         var _loc2_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setLeading(3).setAutoSize(TextFieldAutoSize.LEFT).setVerticalAlign(VerticalAlign.TOP).setMultiLine(true).setWordWrap(true).setPosition(this.PADDING,this.PADDING).setTextWidth(this.WIDTH - 2 * this.PADDING).setTextHeight(this.HEIGHT - 2 * this.PADDING);
         _loc2_.setStringBuilder(new LineBuilder().setParams(param1));
         return _loc2_;
      }
   }
}

