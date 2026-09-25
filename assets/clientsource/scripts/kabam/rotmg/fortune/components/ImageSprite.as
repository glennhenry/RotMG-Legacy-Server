package kabam.rotmg.fortune.components
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ImageSprite extends Sprite
   {
      
      public var displayOb_:DisplayObject;
      
      public function ImageSprite(param1:DisplayObject, param2:Number, param3:Number)
      {
         super();
         this.displayOb_ = param1;
         addChild(param1);
         this.width = param2;
         this.height = param3;
      }
      
      public function setXPos(param1:Number) : void
      {
         this.x = param1 - this.width / 2;
      }
      
      public function setYPos(param1:Number) : void
      {
         this.y = param1 - this.height / 2;
      }
      
      public function getCenterX() : Number
      {
         return this.x + this.width / 2;
      }
      
      public function getCenterY() : Number
      {
         return this.y + this.height / 2;
      }
   }
}

