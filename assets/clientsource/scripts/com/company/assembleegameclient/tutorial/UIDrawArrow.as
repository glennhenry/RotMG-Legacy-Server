package com.company.assembleegameclient.tutorial
{
   import com.company.util.ConversionUtil;
   import com.company.util.PointUtil;
   import flash.display.Graphics;
   import flash.geom.Point;
   
   public class UIDrawArrow
   {
      
      public var p0_:Point;
      
      public var p1_:Point;
      
      public var color_:uint;
      
      public const ANIMATION_MS:int = 500;
      
      public function UIDrawArrow(param1:XML)
      {
         super();
         var _loc2_:Array = ConversionUtil.toPointPair(param1);
         this.p0_ = _loc2_[0];
         this.p1_ = _loc2_[1];
         this.color_ = uint(param1.@color);
      }
      
      public function draw(param1:int, param2:Graphics, param3:int) : void
      {
         var _loc6_:Point = null;
         var _loc4_:Point = new Point();
         if(param3 < this.ANIMATION_MS)
         {
            _loc4_.x = this.p0_.x + (this.p1_.x - this.p0_.x) * param3 / this.ANIMATION_MS;
            _loc4_.y = this.p0_.y + (this.p1_.y - this.p0_.y) * param3 / this.ANIMATION_MS;
         }
         else
         {
            _loc4_.x = this.p1_.x;
            _loc4_.y = this.p1_.y;
         }
         param2.lineStyle(param1,this.color_);
         param2.moveTo(this.p0_.x,this.p0_.y);
         param2.lineTo(_loc4_.x,_loc4_.y);
         var _loc5_:Number = PointUtil.angleTo(_loc4_,this.p0_);
         _loc6_ = PointUtil.pointAt(_loc4_,_loc5_ + Math.PI / 8,30);
         param2.lineTo(_loc6_.x,_loc6_.y);
         _loc6_ = PointUtil.pointAt(_loc4_,_loc5_ - Math.PI / 8,30);
         param2.moveTo(_loc4_.x,_loc4_.y);
         param2.lineTo(_loc6_.x,_loc6_.y);
      }
   }
}

