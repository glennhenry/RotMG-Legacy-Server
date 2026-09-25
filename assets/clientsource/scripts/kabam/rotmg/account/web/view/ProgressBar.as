package kabam.rotmg.account.web.view
{
   import flash.display.Sprite;
   
   public class ProgressBar extends Sprite
   {
      
      private static const BEVEL:int = 4;
      
      private var _w:Number = 100;
      
      private var _h:Number = 10;
      
      private var backbar:Sprite;
      
      private var fillbar:Sprite;
      
      public function ProgressBar(param1:Number, param2:Number)
      {
         super();
         this._w = param1;
         this._h = param2;
         this.backbar = new Sprite();
         this.fillbar = new Sprite();
         addChild(this.backbar);
         addChild(this.fillbar);
         this.update(0);
      }
      
      public function update(param1:Number) : void
      {
         this.drawRectToSprite(this.fillbar,16777215,param1 * 0.01 * this._w);
         this.drawRectToSprite(this.backbar,0,this._w);
      }
      
      private function drawRectToSprite(param1:Sprite, param2:uint, param3:Number) : Sprite
      {
         param1.graphics.clear();
         param1.graphics.beginFill(param2);
         param1.graphics.drawRect(0,0,param3,this._h);
         param1.graphics.endFill();
         return param1;
      }
   }
}

