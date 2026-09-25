package com.company.assembleegameclient.tutorial
{
   import com.company.util.ConversionUtil;
   import flash.display.Graphics;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class UIDrawBox
   {
      
      public var rect_:Rectangle;
      
      public var color_:uint;
      
      public const ANIMATION_MS:int = 500;
      
      public const ORIGIN:Point = new Point(250,200);
      
      public function UIDrawBox(param1:XML)
      {
         super();
         this.rect_ = ConversionUtil.toRectangle(param1);
         this.color_ = uint(param1.@color);
      }
      
      public function draw(param1:int, param2:Graphics, param3:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = this.rect_.width - param1;
         var _loc7_:Number = this.rect_.height - param1;
         if(param3 < this.ANIMATION_MS)
         {
            _loc4_ = this.ORIGIN.x + (this.rect_.x - this.ORIGIN.x) * param3 / this.ANIMATION_MS;
            _loc5_ = this.ORIGIN.y + (this.rect_.y - this.ORIGIN.y) * param3 / this.ANIMATION_MS;
            _loc6_ *= param3 / this.ANIMATION_MS;
            _loc7_ *= param3 / this.ANIMATION_MS;
         }
         else
         {
            _loc4_ = this.rect_.x + param1 / 2;
            _loc5_ = this.rect_.y + param1 / 2;
         }
         param2.lineStyle(param1,this.color_);
         param2.drawRect(_loc4_,_loc5_,_loc6_,_loc7_);
      }
   }
}

